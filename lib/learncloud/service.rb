require 'json'
require 'active_support/core_ext/hash/keys'
require 'logging'

module Learncloud
  class Service
    def initialize
      $logger = Logging.logger['learncloud']
      $logger.level = Learncloud.config.log_level
      $logger.add_appenders(Logging.appenders.stdout, Logging.appenders.file(Learncloud.config.log_file)) unless
        Learncloud.config.log_file == '' || Learncloud.config.log_file.nil?

      @app_id = Learncloud.config.app_id
      @app_key = Learncloud.config.app_key
      @host = 'https://api.leancloud.cn/1.1'
      @verify_test_code = Learncloud.config.verify_test_code if ENV['RAILS_ENV'] == 'test'
      $logger.warn "#{Time.now} a new Learncloud service is created, app id is #{@app_id}, app key is #{@app_key}"
    end

    # 发送验证码
    # params:
    # phone 目标手机号码 phone='13555555555' 目前只做国内用户
    # template 模板名称
    # ttl 验证码有效时间。单位分钟（默认为 10 分钟）
    def sms_code(phone, template, ttl = 10)
      $logger.warn "#{Time.now} send sms_code, phone is #{phone} and template is #{template}"
      url = URI.parse("#{@host}/requestSmsCode")
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      resp = http.post(url.path, {'mobilePhoneNumber': phone, 'template': template, 'ttl': ttl}.to_json,
                       {'Content-Type' => 'application/json', 'X-LC-Id' => @app_id, 'X-LC-Key' => @app_key })
      $logger.warn "#{Time.now} send sms_code result is #{resp.body}"
      res = JSON.parse resp.body
    end

    # 校验验证码
    # params:
    # phone 目标手机号码 phone='13555555555' 目前只做国内用户
    # sms_code: 验证码
    def verify_sms_code(sms_code, phone)
      $logger.warn "#{Time.now} verify sms_code, phone is #{phone} and sms_code is #{sms_code}"
      if ENV['RAILS_ENV'] == 'test'
        case @verify_test_code
          when '200'
            {}
          when '127'
            {'code' => 127, 'error' => '无效的手机号码.'}
          when '401'
            {'code' => 401, 'error' => 'Unauthorized.'}
          when '603'
            {'code' => 603, 'error' => '无效的短信验证码'}
          else
            {} # 待处理
        end
      else
        url = URI.parse("#{@host}/verifySmsCode/#{sms_code}?mobilePhoneNumber=#{phone}")
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        resp = http.post(url.path, {}.to_json,
                         {'Content-Type' => 'application/json', 'X-LC-Id' => @app_id, 'X-LC-Key' => @app_key})
        $logger.warn "#{Time.now} verify sms_code result is #{resp.body}"
        res = JSON.parse resp.body
      end
    end
  end
end