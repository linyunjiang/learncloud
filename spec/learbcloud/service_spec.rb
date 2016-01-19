require 'spec_helper'
require 'yaml'
require 'active_support/core_ext/hash/keys'

describe Learncloud::Service do
  before(:all) do
    LEARNCLOUD_CONFIG = YAML.load(File.open(Learncloud.root + '/config.yml')).symbolize_keys
    @deault_config = LEARNCLOUD_CONFIG[:learncloud].symbolize_keys
    Learncloud.configure do |config|
      config.app_id = @deault_config[:app_id]
      config.app_key = @deault_config[:app_key]
      config.log_file = @deault_config[:log_file]
      config.log_level = @deault_config[:log_level]
    end
    @service = Learncloud::Service.new
  end

  it 'should send sms_code' do
    res_hash = @service.sms_code('159********', '****')
    expect(res_hash).to eq({})
  end

  it 'should verify sms_code success' do
    res_hash = @service.verify_sms_code('175184', '159********')
    expect(res_hash).to eq({})
  end
end
