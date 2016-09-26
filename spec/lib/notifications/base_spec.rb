require 'spec_helper'
require 'nokogiri'

describe YandexKassaForm::Notification::Base do
  include LoaderMacro
  let (:valid_password) { 's<kY23653f,{9fcnshwq' }
  let (:params) { load_params('generic_body.txt') }

  def base(params)
    YandexKassaForm::Notification::Base.new params
  end

  describe '.valid_signature?' do
    it do
      params[:shopPassword] = valid_password
      expect(base(params).valid_signature?).to be true
    end
    
    it do
      params[:shopPassword] = 'any other'
      expect(base(params).valid_signature?).to be false
    end
  end

  describe '.response' do
    let (:node) { @doc.xpath(YandexKassaForm::Notification::Base::RESP_TAG) }
    
    context 'check fields when right password' do
      before :each do
        params[:shopPassword] = valid_password
        @doc = Nokogiri::XML(base(params).response)
      end
      
      it { expect(node.attr('code').value).to eq '0' }
      it { expect(node.attr('invoiceId').value).to eq '55' }
      it { expect(node.attr('shopId').value).to eq '13' }
      it { expect(node.attr('performedDatetime').value).not_to be_empty }
    end
    
    context 'check fields when wrong password' do
      before :each do
        params[:shopPassword] = 'wrong'
        @doc = Nokogiri::XML(base(params).response)
      end
      
      it { expect(node.attr('code').value).to eq '1' }
    end
  end
end
