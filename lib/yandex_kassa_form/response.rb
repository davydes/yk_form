module YandexKassaForm
  module Response
    extend self
    
    def resp_tag(notification)
      case notification.class
        when YandexKassaForm::Notification::CheckOrder
          'checkOrderResponse'
        when YandexKassaForm::Notification::CancelOrder
          'cancelOrderResponse'
        when YandexKassaForm::Notification::PaymentAviso
          'paymetAvisoResponse'
        else
          'baseResponse'
      end
    end
    
    def generate(notification)
      props = {
        performedDatetime: Time.now.iso8601,
        code: notification.code,
        invoiceId: notification.params[:invoiceId],
        shopId: notification.params[:shopId]
      }
      props.merge!(message: notification.message) if notification.code != 0 && notification.message
     
      xml = Builder::XmlMarkup.new
      xml.instruct! :xml, version: '1.0', encoding: 'UTF-8'
      xml.tag! resp_tag(notification), props
      xml.target!
    end
  end
end
