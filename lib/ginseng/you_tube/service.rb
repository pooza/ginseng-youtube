module Ginseng
  module YouTube
    class Service
      include Package

      def initialize
        @config = config_class.instance
        @http = http_class.new
        @http.base_uri = @config['/youtube/url']
      end

      def lookup_video(id)
        uri = @http.create_uri('/youtube/v3/videos')
        uri.query_values = {
          'part' => 'snippet,statistics',
          'key' => api_key,
          'id' => id,
        }
        response = @http.get(uri)
        return nil unless response['items'].present?
        return response['items'].first
      rescue => e
        raise wrap_error(e, "invalid video '#{id}'"), cause: nil
      end

      def lookup_channel(id)
        uri = @http.create_uri('/youtube/v3/channels')
        uri.query_values = {
          'part' => 'snippet',
          'key' => api_key,
          'id' => id,
        }
        response = @http.get(uri)
        return nil unless response['items'].present?
        return response['items'].first
      rescue => e
        raise wrap_error(e, "invalid channel '#{id}'"), cause: nil
      end

      def search_channels(keyword)
        uri = @http.create_uri('/youtube/v3/search')
        uri.query_values = {
          'part' => 'snippet',
          'key' => api_key,
          'q' => keyword,
          'type' => 'channel',
        }
        response = @http.get(uri)
        return nil unless response['items'].present?
        return response['items'].first
      rescue => e
        # 🔴 もとは未定義の `id` を参照していて、失敗が全部 `NameError` になっていた (#24)。
        raise wrap_error(e, "invalid search '#{keyword}'"), cause: nil
      end

      def api_key
        return @config['/google/api/key']
      end

      private

      # 失敗を `GatewayError` に包み直す (#28)。
      #
      # ⚠ **上流の応答を引き継ぐ。** 元が `GatewayError` なら `response` を添える。添えないと
      # メッセージが `)` で終わるので状態コードを復元できず、上流が 403 でも `source_status` が 502 になる。
      # ⚠ ginseng-core 7.1.0 からの `rejection`（拒否の理由）も引き継ぐ。
      #
      # 🔴 **元のメッセージの URL は伏せる。** HTTParty の `UnsupportedURIScheme` は URL を丸ごと
      # メッセージに載せるので、`/youtube/url` を http 以外に誤設定すると API キーがクエリごと出る。
      # ginseng-core 3.0.0 からは core の側でも伏せている（ginseng-core#703）が、
      # 床（1.23.1）の core では伏せていない。⚠ `mask_urls_in` は 1.23.1 にもある。
      # 🔴 **呼ぶ側は `cause: nil` で上げる（リリース前レビュー）。** `rescue` の中の `raise` は元の例外を
      # `cause` に付けるので、床の core ではそこに API キーが平文で残り、`full_message` や Sentry が辿る。
      def wrap_error(error, context)
        wrapped = Ginseng::GatewayError.new("#{context} (#{Ginseng::Logger.new.mask_urls_in(error.message.to_s)})")
        return wrapped unless error.is_a?(Ginseng::GatewayError)
        wrapped.response = error.response
        wrapped.rejection = error.rejection if wrapped.respond_to?(:rejection=)
        return wrapped
      end
    end
  end
end
