module Ginseng
  module YouTube
    class ChannelURI < Ginseng::URI
      include Package

      def initialize(options = {})
        super
        @service = you_tube_service_class.new
      end

      def id
        return query_values['v']
      rescue
        return nil
      end

      def data
        @data ||= @service.lookup_channel(id)
        return @data
      end

      def title
        return data.dig('snippet', 'title')
      end

      def channel_title
        return data.dig('snippet', 'channelTitle')
      end

      def channel_id
        return data.dig('snippet', 'channelId')
      end

      alias channnel channel_title
    end
  end
end
