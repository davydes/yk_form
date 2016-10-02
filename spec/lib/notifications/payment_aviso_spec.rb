require 'spec_helper'
require 'nokogiri'

describe YandexKassaForm::Notification::PaymentAviso do
  before { stub_const 'BODY_FILE', 'payment_aviso.txt'}

  def notification(block)
    YandexKassaForm::Notification::PaymentAviso.new request, &block
  end

  describe '.initialize' do
    it do
      expect do
        YandexKassaForm::Notification::PaymentAviso.new request
      end.to raise_error ArgumentError
    end
  end

  describe '.code' do
    it { expect(notification(TRUE_PROC).code).to be 0 }
   
    it do
      stub_const('PASSWORD', PASSWORD_INVALID)
      expect(notification(TRUE_PROC).code).to be 1
    end
    
    context 'when block has exception' do
      block = lambda { |params| raise StandartError }
      it { expect(notification(block).code).to be 200 }
    end
  end
end
