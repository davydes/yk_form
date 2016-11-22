[![Build Status](https://travis-ci.org/davydes/yk_form.svg?branch=master)](https://travis-ci.org/davydes/yk_form)
[![Code Climate](https://codeclimate.com/github/davydes/yk_form/badges/gpa.svg)](https://codeclimate.com/github/davydes/yk_form)
[![Test Coverage](https://codeclimate.com/github/davydes/yk_form/badges/coverage.svg)](https://codeclimate.com/github/davydes/yk_form/coverage)

# YandexKassaForm

[Yandex Kassa Integration by HTTP](https://tech.yandex.ru/money/doc/payment-solution/payment-notifications/payment-notifications-http-docpage)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'yk_form', github: 'davydes/yk_form'
```

And then execute:

    $ bundle

## Usage

```ruby
require 'yandex_kassa_form'

# Initialize module
YandexKassaForm.configure do |cfg|
  cfg.shop_id = 13
  cfg.shop_password = 's<kY23653f,{9fcnshwq'

  # This block called when check order received
  # You should return array with 1 or 2 values
  # First value must be boolean: true - success, false - fail
  # If first is false, second should be contain message
  # Message will be ignored when first value is true
  cfg.check_order = lambda do |params|
    puts 'Here is real check data in Order'
    params.each { |k,v| puts "#{k} = #{v}" }
    check_result = false
    [check_result, 'Ooopps']
  end

  # This block called when payment aviso received
  # In the block you should save data about payment to you DB, for example
  cfg.save_payment = lambda do |params|
    puts 'Do somthing to store data about this payment'
    params.each { |k,v| puts "#{k} = #{v}" }
  end
end

rq = File.new('/home/developer3/my/yk_form/spec/support/files/check_order.txt').read
puts "Received request: \n=== BEGIN\n#{rq}\n=== END"
rp = YandexKassaForm.handler rq
puts "Send response: \n#{rp}"

rq = File.new('/home/developer3/my/yk_form/spec/support/files/payment_aviso.txt').read
puts "Received request: \n=== BEGIN\n#{rq}\n=== END"
rp = YandexKassaForm.handler rq
puts "Send response: \n#{rp}"
```

## Rails example

*config/initializers/yandex.rb*
```ruby
require 'yandex_kassa_form'
require 'yandex'

YandexKassaForm.configure do |cfg|
  cfg.shop_id = ENV['YK_SHOPID']
  cfg.shop_password = ENV['YK_PASSWORD']
  cfg.check_order = -> (params) { Yandex.instance.check_order(params) }
  cfg.save_payment = -> (params) { Yandex.instance.save_payment(params) }
end
```

*app/controllers/yandex/rb*
```ruby
class YandexController < ActionController::Base
  def handle
    render body: YandexKassaForm.handler(request.raw_post),
           content_type: 'application/xml'
  end
end
```

*config/routes.rb*
```ruby
Rails.application.routes.draw do

  post 'yandexkassa' => 'yandex#handle'

end
```

*lib/yandex.rb*

The file containts main logic about how you handle yours data.

```ruby
require 'singleton'

class Yandex
  include Singleton

  def logger
    return @logger if @logger
    @logger = Logger.new(Rails.root.join('log','yandex.log'))
    @logger.level = 0
    @logger
  end

  def check_order(params)
    logger.info("check_order: #{params.inspect}")
    order = Order.find_by_id(params[:orderNumber])

    unless order
      result = [false, 'Order not found!']
    end

    if result.nil?
      sum_equals = order.cost == BigDecimal(params[:orderSumAmount])
      result = [sum_equals, 'Sum does not match!']
    end

    logger.info("returned #{result.inspect}")
    result
  rescue => e
    logger.error(e.message)
    logger.error(e.backtrace.join("\n"))
    raise e
  end

  def save_payment(params)
    logger.info("save_payment: #{params.inspect}")
    order = Order.find_by_id!(params[:orderNumber])
    order.paid!
    logger.info("Order #{order.id} marked as paid.")
  rescue => e
    logger.error(e.message)
    logger.error(e.backtrace.join("\n"))
    raise e
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/davydes/yk_form. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

