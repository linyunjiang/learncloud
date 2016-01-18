# Learncloud
用于封装learncloud短信验证rest api, https://leancloud.cn/docs/rest_sms_api.html

## 安装

Add this line to your application's Gemfile:

```ruby
gem 'learncloud'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install learncloud

## 初始化
```ruby
Learncloud.configure do |config|
  config.app_id = ''
  config.app_key = ''
  config.log_file = ''
  config.log_level = :warn
end
@service = Learncloud::Service.new
```

## 接口

发送验证码
参数: phone 目标手机号码 phone='13555555555' 目前只做国内用户
     template 短信模板名称
     ttl 验证码有效时间。单位分钟（默认为 10 分钟）
```ruby
@service.sms_code(phone, template, ttl)
```

校验验证码
参数: phone
     sms_code 验证码

```ruby
@service.verify_sms_code(sms_code, phone)
```

###

