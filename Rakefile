dir = File.expand_path(__dir__)
$LOAD_PATH.unshift(File.join(dir, 'lib'))
ENV['BUNDLE_GEMFILE'] = File.join(dir, 'Gemfile')

require 'ginseng/you_tube'

namespace :bundle do
  desc 'update gems'
  task :update do
    sh 'bundle update'
  end

  desc 'install bundler'
  task :install_bundler do
    sh 'gem install bundler'
  end

  desc 'check gems'
  task check: [:install_bundler] do
    unless Ginseng::YouTube::Environment.gem_fresh?
      warn 'gems is not fresh.'
      exit 1
    end
  end
end

desc 'test all'
task :test do
  Ginseng::YouTube::TestCase.load((ARGV.first&.split(/[^[:word:],]+/) || [])[1])
end
