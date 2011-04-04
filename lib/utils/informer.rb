module Utils
  class Informer
    cattr_accessor :debugging
    cattr_reader :logger
    @@logger = Logger.new(File.join(Rails.root, "log", "informer.log"))
  end
end
