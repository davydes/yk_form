require 'yandex_kassa_form/version'
require 'yandex_kassa_form/configuration'
require 'yandex_kassa_form/params'
require 'yandex_kassa_form/response'
require 'yandex_kassa_form/notification/base'
require 'yandex_kassa_form/notification/check_order'
require 'yandex_kassa_form/notification/cancel_order'
require 'yandex_kassa_form/notification/payment_aviso'

module YandexKassaForm
  extend self

  def configure(&block)
    yield configuration
  end

  def configuration
    @configuration ||= Configuration.new
  end

  def handler(body)
    params = Params.parse body
    params[:shopId] = configuration.shop_id
    params[:password] = configuration.shop_password
    Params.require! params
    
    notification =
      case params[:action]
        when 'checkOrder' then
          Notification::CheckOrder.new(params, configuration.check_order)
        when 'cancelOrder' then
          Notification::CancelOrder.new(params)
        when 'paymentAviso' then
          Notification::PaymentAviso.new(params)
        else
          raise ArgumentError.new("Unknown Action [#{params[:action]}]")
      end
    YandexKassaForm::Response.generate(notification)
  end
end
