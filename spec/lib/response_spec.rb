require 'spec_helper'
require 'nokogiri'

describe YandexKassaForm::Response do
  describe '.resp_tag' do
    it do
      notification = YandexKassaForm::Notification::Base.new request
      expect(YandexKassaForm::Response.resp_tag(notification)).to eq 'baseResponse'
    end
    it do
      notification = YandexKassaForm::Notification::CheckOrder.new request, &TRUE_PROC
      expect(YandexKassaForm::Response.resp_tag(notification)).to eq 'checkOrderResponse'
    end
    it do
      notification = YandexKassaForm::Notification::PaymentAviso.new request, &TRUE_PROC
      expect(YandexKassaForm::Response.resp_tag(notification)).to eq 'paymentAvisoResponse'
    end
    it do
      notification = YandexKassaForm::Notification::CancelOrder.new request
      expect(YandexKassaForm::Response.resp_tag(notification)).to eq 'cancelOrderResponse'
    end
  end

  describe '.generate' do
    let (:node) { @document.xpath(@tag_resp) }
    def subject(object)
      YandexKassaForm::Response.generate(object)
    end

    context 'fields' do
      before { @tag_resp = 'baseResponse'}
      def object
        YandexKassaForm::Notification::Base.new(request)
      end
      
      context 'when right password' do
        before :each do
          @document = Nokogiri::XML(subject(object))
        end
        
        it { expect(node.attr('code').value).to eq '0' }
        it { expect(node.attr('invoiceId').value).to eq '55' }
        it { expect(node.attr('shopId').value).to eq '13' }
        it { expect(node.attr('performedDatetime').value).not_to be_empty }
        it { expect(node.attr('message')).to be_nil }
      end
      
      context 'code' do
        before :each do
          stub_const('PASSWORD', PASSWORD_INVALID)
          @document = Nokogiri::XML(subject(object))
        end
        
        it { expect(node.attr('code').value).to eq '1' }
      end
      
      context 'message' do
        context 'when message filled & code != 0' do
          before :each do
            stub_const('PASSWORD', PASSWORD_INVALID)
            n = object
            n.message = ERROR_MESSAGE
            @document = Nokogiri::XML(subject(n))
          end
          
          it { expect(node.attr('message').value).to eq ERROR_MESSAGE }
        end
        
        context 'when message filled & code = 0' do
          before :each do
            n = object
            n.message = ERROR_MESSAGE
            @document = Nokogiri::XML(subject(n))
          end
          
          it { expect(node.attr('message')).to be_nil }
        end
      end
    end
  end
end
