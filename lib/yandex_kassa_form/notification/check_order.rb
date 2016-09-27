module YandexKassaForm
  module Notification
    class CheckOrder < Base
      RESP_TAG = 'checkOrderResponse'
      
      def initialize(params, &block)
        @check_block = block
        raise ArgumentError unless @check_block.respond_to?(:call)
        super
      end
      
      private
      
      def check!
        return @code if @code
        
        @code = super
        return @code if @code != 0
        
        result = @check_block.call(@params)
        unless result.is_a?(Array) || !!result[0] = result[0]
          raise TypeError
        end
        
        unless result[0]
          @message = result[1] if result[1].is_a?(String)
        end
        
        @code = result[0] ? 0 : 100        
      rescue TypeError
        @code = 100
      end
    end
  end
end
