require 'builder'

module YandexKassaForm
  module Notification
    class Base
      def initialize(params)
        @params = params
      end
     
      def response
        xml = Builder::XmlMarkup.new
        xml.instruct! :xml, version: '1.0', encoding: 'UTF-8'
       
        xml.Response(
          performedDatetime: Time.current.iso8601,
          code: code,
          invoiceId: params[:invoice_id],
          shopId: params[:shopId]
        )
        xml.target!
      end

      def valid_signature?
        signature != params[:md5]
      end
     
      private

      def code
        valid_signature? ? '0' : '1'
      end
     
      def signature_data
        Params::SIGNATURE_PARAMS.map { |name| @params[name] }
      end
     
      def signature
        Digest::MD5.hexdigest(signature_data.join(';')).upcase
      end
    end
  end
end
