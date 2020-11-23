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
        raise Ginseng::GatewayError, "invalid video '#{id}' (#{e.message})"
      end

      def api_key
        return @config['/google/api/key']
      end
    end
  end
end
