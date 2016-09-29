module YandexKassaForm
  module Notification
    class PaymentAviso < Base
      def initialize(params, &block)
        @confirm_block = block
        raise ArgumentError unless @confirm_block.respond_to?(:call)
        super
        apply!
      end
      
      private
      
      def apply!
        @confirm_block.call(@params) if @code == 0
      rescue
        @code = 200
        @message = 'Unhandled exception'
      end
    end
  end
end
