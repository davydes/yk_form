module YandexKassaForm
  module Request
    extend self
   
    SIGNATURE_PARAMS = [
      :action,
      :orderSumAmount,
      :orderSumCurrencyPaycash,
      :orderSumBankPaycash,
      :shopId,
      :invoiceId,
      :customerNumber,
      :shopPassword
    ] 
   
    def parse(body)
      body.chomp.split("&").map do |param|
        corresponders = param.split("=")
        [corresponders[0].to_sym, corresponders[1]]
      end.to_h
    end

    def require!(hash)
      missings = SIGNATURE_PARAMS - hash.reject{ |_,v| v.nil? || (v.is_a?(String) && v.empty?) }.keys
      if (missings).any?
        raise ArgumentError.new("Missings params #{missings}")
      end
      hash
    end
  end
end
