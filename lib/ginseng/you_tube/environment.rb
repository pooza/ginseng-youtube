module Ginseng
  module YouTube
    class Environment < Ginseng::Environment
      def self.name
        return File.basename(dir)
      end

      def self.dir
        return Ginseng::YouTube.dir
      end
    end
  end
end
