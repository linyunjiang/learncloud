require 'spec_helper'
require 'yaml'
require 'active_support/core_ext/hash/keys'

describe Learncloud::Configuration do
  before(:all) do
    LEARNCLOUD_CONFIG = YAML.load(File.open(Learncloud.root + '/config.yml')).symbolize_keys
    @deault_config = LEARNCLOUD_CONFIG[:learncloud].symbolize_keys
  end

  it 'should setup config' do
    Learncloud.configure do |config|
      config.app_id = @deault_config[:app_id]
      config.app_key = @deault_config[:app_key]
    end
    expect(Learncloud.config.app_id).to eql(@deault_config[:app_id])
  end
end
