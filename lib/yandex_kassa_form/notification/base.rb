require 'builder'
require 'time'

module YandexKassaForm
  module Notification
    class Base
      attr_accessor :message, :code, :params
     
      def initialize(params)
        @params = params
        check!
      end
     
      def valid_signature?
        signature == @params[:md5]
      end
      
      private
      
      def check!
        @code ||= valid_signature? ? 0 : 1
      end
      
      def signature_data
        Request::SIGNATURE_PARAMS.map { |name| @params[name] }
      end
     
      def signature
        Digest::MD5.hexdigest(signature_data.join(';')).upcase
      end
    end
  end
end
