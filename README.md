# YandexKassaForm

[Yandex Kassa Integration by HTTP](https://tech.yandex.ru/money/doc/payment-solution/payment-notifications/payment-notifications-http-docpage)

## !!! This Gem under construction !!!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'yk_form'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install yk_form

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

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/davydes/yk_form. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

