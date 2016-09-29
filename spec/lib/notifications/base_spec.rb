require 'spec_helper'

describe YandexKassaForm::Notification::Base do
  def notification(params)
    YandexKassaForm::Notification::Base.new params
  end

  describe '.valid_signature?' do
    it { expect(notification(request).valid_signature?).to be true }
    it do
      stub_const('PASSWORD', PASSWORD_INVALID)
      expect(notification(request).valid_signature?).to be false
    end
  end

  describe '.code' do
    it { expect(notification(request).code).to be 0 }
    it do
      stub_const('PASSWORD', PASSWORD_INVALID)
      expect(notification(request).code).to be 1
    end
  end
end
