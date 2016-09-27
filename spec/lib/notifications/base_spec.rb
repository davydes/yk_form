require 'spec_helper'
require 'nokogiri'

describe YandexKassaForm::Notification::Base do
  include LoaderMacro
  let (:valid_password) { 's<kY23653f,{9fcnshwq' }
  let (:invalid_password) { 'invalid' }
  let (:error_message) { 'message when errored' }
  let (:params) { load_params('generic_body.txt') }
  let (:good_params) { params.merge!(shopPassword: valid_password) }
  let (:bad_params) { params.merge!(shopPassword: invalid_password) }

  def notification(params)
    YandexKassaForm::Notification::Base.new params
  end

  describe '.valid_signature?' do
    it { expect(notification(good_params).valid_signature?).to be true }
    it { expect(notification(bad_params).valid_signature?).to be false }
  end

  describe '.code' do
    it { expect(notification(good_params).code).to be 0 }
    it { expect(notification(bad_params).code).to be 1 }
  end

  describe '.response' do
    let (:node) { @doc.xpath(YandexKassaForm::Notification::Base::RESP_TAG) }
    
    context 'fields when right password' do
      before :each do
        @doc = Nokogiri::XML(notification(good_params).response)
      end
      
      it { expect(node.attr('code').value).to eq '0' }
      it { expect(node.attr('invoiceId').value).to eq '55' }
      it { expect(node.attr('shopId').value).to eq '13' }
      it { expect(node.attr('performedDatetime').value).not_to be_empty }
      it { expect(node.attr('message')).to be_nil }
    end
    
    context 'code field' do
      before :each do
        @doc = Nokogiri::XML(notification(bad_params).response)
      end
      
      it { expect(node.attr('code').value).to eq '1' }
    end
    
    context 'message field' do
      context 'when message filled & code != 0' do
        before :each do
          notification = notification(bad_params)
          notification.message = error_message
          @doc = Nokogiri::XML(notification.response)
        end
        
        it { expect(node.attr('message').value).to eq error_message }
      end
      
      context 'when message filled & code = 0' do
        before :each do
          notification = notification(good_params)
          notification.message = error_message
          @doc = Nokogiri::XML(notification.response)
        end
        
        it { expect(node.attr('message')).to be_nil }
      end
    end
  end
end
