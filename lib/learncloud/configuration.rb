require 'active_support/configurable'

module Learncloud
  # Configures global settings for Learncloud
  #   Learncloud.configure do |config|
  #     config.app_key = 10
  #   end
  def self.configure(&block)
    yield @config ||= Learncloud::Configuration.new
  end

  # Global settings for Learncloud
  def self.config
    @config
  end

  class Configuration  #:nodoc:
    include ActiveSupport::Configurable
    config_accessor :app_id, :app_key, :log_file, :log_level, :verify_test_code
  end

  # this is ugly. why can't we pass the default value to config_accessor...?
  configure do |config|
    config.app_id = ''
    config.app_key = ''
    config.log_file = ''
    config.log_level = :warn
    config.verify_test_code = '200'
  end
end
