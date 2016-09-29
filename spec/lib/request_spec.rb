require 'spec_helper'

describe YandexKassaForm::Request do
  describe '.parse' do
    context 'returned' do
      it { expect(YandexKassaForm::Request.parse(load_file(BODY_FILE))).to be_a Hash }

      context 'keys' do
        it { expect(YandexKassaForm::Request.parse(load_file(BODY_FILE)).keys).to all(be_a Symbol) }
      end
    end
  end

  describe '.require!' do
    context 'returned' do
      it do
        hash = YandexKassaForm::Request::SIGNATURE_PARAMS.map{ |k| [k,'sample'] }.to_h
        expect(YandexKassaForm::Request.require!(hash)).to be hash
      end
    end
   
    context 'raised' do
      it do
        expect do 
          YandexKassaForm::Request.require!({})
        end.to raise_error(ArgumentError, /#{Regexp.quote YandexKassaForm::Request::SIGNATURE_PARAMS.to_s}/)
      end
     
      it do
        hash = YandexKassaForm::Request::SIGNATURE_PARAMS.map{ |k| [k,'sample'] }.to_h
        param = hash.shift[0]
        expect do         
          YandexKassaForm::Request.require!(hash)
        end.to raise_error(ArgumentError, /#{Regexp.quote [param].to_s}/)
      end
    end
  end
end
