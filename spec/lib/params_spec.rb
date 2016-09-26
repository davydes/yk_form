require 'spec_helper'

describe YandexKassaForm::Params do
  describe '.parse' do
    include LoaderMacro
    loader :body, 'generic_body.txt'
   
    context 'returned' do
      it { expect(YandexKassaForm::Params.parse(body)).to be_a Hash }

      context 'keys' do
        it { expect(YandexKassaForm::Params.parse(body).keys).to all(be_a Symbol) }
      end
    end
  end

  describe '.require!' do
    context 'returned' do
      it do
        hash = YandexKassaForm::Params::SIGNATURE_PARAMS.map{ |k| [k,'sample'] }.to_h
        expect(YandexKassaForm::Params.require!(hash)).to be hash
      end
    end
   
    context 'raised' do
      it do
        expect do 
          YandexKassaForm::Params.require!({})
        end.to raise_error(ArgumentError, /#{Regexp.quote YandexKassaForm::Params::SIGNATURE_PARAMS.to_s}/)
      end
     
      it do
        hash = YandexKassaForm::Params::SIGNATURE_PARAMS.map{ |k| [k,'sample'] }.to_h
        param = hash.shift[0]
        expect do         
          YandexKassaForm::Params.require!(hash)
        end.to raise_error(ArgumentError, /#{Regexp.quote [param].to_s}/)
      end
    end
  end
end
