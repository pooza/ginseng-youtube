module Ginseng
  module YouTube
    class ServiceTest < Test::Unit::TestCase
      def setup
        @service = Service.new
      end

      def test_lookup_video
        video = @service.lookup_video('uFfsTeExwbQ')

        assert_kind_of(Hash, video)
        assert_predicate(video, :present?)
        assert_equal('【キラキラ☆プリキュアアラモード】後期エンディング 「シュビドゥビ☆スイーツタイム」 （歌：宮本佳那子）', video.dig('snippet', 'title'))
      end

      def test_lookup_channel
        channel = @service.lookup_channel('UCSsjL41NsyqSNNbanuI0htg')

        assert_kind_of(Hash, channel)
        assert_predicate(channel, :present?)
        assert_equal('プリキュア公式YouTubeチャンネル', channel.dig('snippet', 'title'))
      end

      # ⚠ **API も網も叩かない。** キーが引けない形で失敗させ、例外の型だけを見る (#24)。
      def test_failures_are_gateway_errors
        @service.define_singleton_method(:api_key) {raise Ginseng::ConfigError, 'no key'}
        {
          lookup_video: 'invalid video',
          lookup_channel: 'invalid channel',
          search_channels: 'invalid search',
        }.each do |method, message|
          error = assert_raise(Ginseng::GatewayError) {@service.send(method, 'x')}
          assert_include(error.message, message)
        end
      end

      # 🔴 **元のメッセージの URL を伏せる (#28)。** 床（1.23.1）の core は包み直すときに伏せないので、
      # core を通さずに素のメッセージを投げさせて、こちらで伏せていることを見る。
      def test_failures_mask_urls_in_message
        url = 'ftp://example.invalid/youtube/v3/search?key=SECRETKEY123&q=x'
        stub_get {raise "'#{url}' Must be HTTP, HTTPS or Generic"}
        each_method do |method|
          error = assert_raise(Ginseng::GatewayError) {@service.send(method, 'x')}
          assert_not_include(error.message, 'SECRETKEY123')
        end
      end

      # ⚠ **上流の応答を引き継ぐ (#28)。** 引き継がないと 403 が 502 に化ける。
      def test_failures_keep_upstream_response
        response = Struct.new(:code, :body).new(403, '{"error":{"code":403}}')
        stub_get do
          error = Ginseng::GatewayError.new('Bad response 403')
          error.response = response
          raise error
        end
        each_method do |method|
          error = assert_raise(Ginseng::GatewayError) {@service.send(method, 'x')}
          assert_same(response, error.response)
          assert_equal(403, error.source_status)
          assert_equal({'error' => {'code' => 403}}, error.source_body)
        end
      end

      # ⚠ core 7.1.0 からの `rejection`（拒否の理由）も引き継ぐ。
      def test_failures_keep_rejection
        stub_get {raise Ginseng::GatewayError.rejected_host("Rejected host 'x'", :unresolvable_host)}
        each_method do |method|
          error = assert_raise(Ginseng::GatewayError) {@service.send(method, 'x')}
          assert_equal(:unresolvable_host, error.rejection)
        end
      end

      # 🔴 元の例外を `cause` に連れて行かない（床の core では、そこに API キーが平文で残る）。
      def test_failures_drop_cause
        stub_get {raise "'ftp://example.invalid/youtube/v3/search?key=SECRETKEY123' Must be HTTP"}
        each_method do |method|
          error = assert_raise(Ginseng::GatewayError) {@service.send(method, 'x')}
          assert_nil(error.cause)
        end
      end

      def test_search_channels
        channels = @service.search_channels('@precure')

        assert_kind_of(Hash, channels)
      end

      private

      # ⚠ `define_singleton_method` に `&block` をそのまま渡すと引数の数が厳密になる（`get` は引数を取る）。
      def stub_get(&block)
        action = block
        @service.define_singleton_method(:api_key) {'SECRETKEY123'}
        @service.instance_variable_get(:@http).define_singleton_method(:get) {|*| action.call}
      end

      def each_method(&)
        [:lookup_video, :lookup_channel, :search_channels].each(&)
      end
    end
  end
end
