require 'spec_helper'

describe YandexKassaForm do
  it 'has a version number' do
    expect(YandexKassaForm::VERSION).not_to be nil
  end

  context '.handle' do
    YandexKassaForm.configure do |cfg|
      cfg.shop_id = 13
      cfg.shop_password = 's<kY23653f,{9fcnshwq'
     
      cfg.check_order = lambda do |params|
        check_result = false
        [check_result, 'Ooopps']
      end
     
      cfg.save_payment = lambda do |params|
        true
      end
    end
    
    it do
      rq = load_file('check_order.txt')
      rp = YandexKassaForm.handler rq
      expect(rp).to match(/checkOrderResponse/)
      expect(rp).to match(/code="100"/)
      expect(rp).to match(/Ooopps/)
    end
    
    it do
      rq = load_file('payment_aviso.txt')
      rp = YandexKassaForm.handler rq
      expect(rp).to match(/paymentAvisoResponse/)
      expect(rp).to match(/code="0"/)
    end
  end
end
