require 'ginseng'
require 'active_support/dependencies/autoload'

module Ginseng
  module YouTube
    extend ActiveSupport::Autoload

    autoload :Config
    autoload :Environment
    autoload :Package
    autoload :Service
    autoload :URI
  end
end
