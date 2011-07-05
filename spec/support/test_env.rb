class TestEnv
  class << self
    def number
      @number ||= (ENV["TEST_ENV_NUMBER"] || 0).to_i + 1
    end

    def host
      @host ||= "#{SiteSettings.name}#{number}.local.com"
    end
  end
end
