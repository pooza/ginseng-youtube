module Ginseng
  module YouTube
    module Package
      def environment_class
        return Environment
      end

      def package_class
        return Package
      end

      def config_class
        return Config
      end

      def http_class
        return Ginseng::HTTP
      end

      def you_tube_service_class
        return Service
      end

      def self.name
        return 'ginseng-youtube'
      end

      def self.version
        return Config.instance['/package/version']
      end

      def self.url
        return Config.instance['/package/url']
      end
    end
  end
end
