module Ginseng
  module YouTube
    class ChannelURI < Ginseng::URI
      include Package

      def initialize(options = {})
        super
        @service = you_tube_service_class.new
      end

      def id
        return path.split('/').last
      end

      def data
        @data ||= @service.lookup_channel(id)
        return @data
      end

      def title
        return data.dig('snippet', 'title')
      end
    end
  end
end
