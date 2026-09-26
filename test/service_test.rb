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

      def test_search_channels
        channels = @service.search_channels('@precure')

        assert_kind_of(Hash, channels)
      end
    end
  end
end
