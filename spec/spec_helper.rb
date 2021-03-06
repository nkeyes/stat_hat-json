$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'support'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'config'))

require 'simplecov'
require 'codeclimate-test-reporter'
SimpleCov.start do
  formatter SimpleCov::Formatter::MultiFormatter[
                SimpleCov::Formatter::HTMLFormatter,
                CodeClimate::TestReporter::Formatter
            ]
end

require 'bundler/setup'

Bundler.require(:default, :test)

RSpec.configure do |config|
  #Run any specs tagged with focus: true or all specs if none tagged
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

end
