RSpec.configure do |config|
  config.before(:suite) do
    MatchingSettings.started_after #trigger settings class initialization
  end
end
