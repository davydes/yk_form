require 'spec_helper'

describe YandexKassaForm::Notification::Base do
  include LoaderMacro
  valid_password = 's<kY23653f,{9fcnshwq'
  invalid_password= 'invalid'
  error_message = 'message when errored'
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
end
