module Ginseng
  module YouTube
    class URI < Ginseng::URI
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
        @data ||= @service.lookup_video(id)
        return @data
      end

      def music?
        return host == 'music.youtube.com'
      end

      def image_uri
        unless @image_uri
          ['standard', 'high', 'medium', 'deault'].each do |size|
            next unless url = data.dig('snippet', 'thumbnails', size, 'url')
            next unless uri = Ginseng::URI.parse(url)
            next unless uri.absolute?
            return @image_uri = uri
          end
        end
        return @image_uri
      end

      def title
        return nil unless data
        return data['snippet']['title']
      end

      def channel
        return nil unless data
        return data['snippet']['channelTitle']
      end

      def artist
        return channel.sub(/ - Topic$/, '') if music?
        return nil
      end

      def view_count
        return nil unless data
        return data['statistics']['viewCount'].to_i
      end

      alias count view_count
    end
  end
end