require 'builder'
require 'time'

module YandexKassaForm
  module Notification
    class Base
      RESP_TAG = 'baseResponse'
      
      attr_accessor :message, :code, :params
     
      def initialize(params)
        @params = params
        check!
      end
     
      def response
        props = {
          performedDatetime: Time.now.iso8601,
          code: code,
          invoiceId: params[:invoiceId],
          shopId: params[:shopId]
        }
        props.merge!(message: message) if code != 0 && message
       
        xml = Builder::XmlMarkup.new
        xml.instruct! :xml, version: '1.0', encoding: 'UTF-8'
        xml.tag! RESP_TAG, props
        xml.target!
      end
      
      def valid_signature?
        signature == @params[:md5]
      end
      
      private

      def check!
        @code ||= valid_signature? ? 0 : 1
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
