$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

# Submit metrics to code climate.
unless ENV['CODECLIMATE_REPO_TOKEN'].nil?
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
end

require 'pry'
require 'rspec'
require 'typist'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rspec
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.color_enabled = true
  config.formatter = :documentation
  config.tty = true
end
