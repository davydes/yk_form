require 'spec_helper'
require 'nokogiri'

describe YandexKassaForm::Response do
  include LoaderMacro
  valid_password = 's<kY23653f,{9fcnshwq'
  invalid_password = 'invalid'
  error_message = 'message when errored'
  let (:node) { @document.xpath(@tag_resp) }

  describe '.generate' do
    context 'tests with Base notification' do
      let (:params) { @params ||= load_params('generic_body.txt') }
      let (:good_params) { params.merge!(shopPassword: valid_password) }
      let (:bad_params) { params.merge!(shopPassword: invalid_password) }
      def object(params) YandexKassaForm::Notification::Base.new(params) end
      def subject(object) YandexKassaForm::Response.generate(object) end
      
      before { @tag_resp = 'baseResponse'}
      
      context 'fields when right password' do
        before :each do
          @document = Nokogiri::XML(subject(object(good_params)))
        end
        
        it { expect(node.attr('code').value).to eq '0' }
        it { expect(node.attr('invoiceId').value).to eq '55' }
        it { expect(node.attr('shopId').value).to eq '13' }
        it { expect(node.attr('performedDatetime').value).not_to be_empty }
        it { expect(node.attr('message')).to be_nil }
      end
      
      context 'code field' do
        before :each do
          @document = Nokogiri::XML(subject(object((bad_params))))
        end
        
        it { expect(node.attr('code').value).to eq '1' }
      end
      
      context 'message field' do
        context 'when message filled & code != 0' do
          before :each do
            object = object(bad_params)
            object.message = error_message
            @document = Nokogiri::XML(subject(object))
          end
          
          it { expect(node.attr('message').value).to eq error_message }
        end
        
        context 'when message filled & code = 0' do
          before :each do
            object = object(good_params)
            object.message = error_message
            @document = Nokogiri::XML(subject(object))
          end
          
          it { expect(node.attr('message')).to be_nil }
        end
      end
    end
  end
end
