require 'spec_helper'
require 'nokogiri'

describe YandexKassaForm::Notification::CheckOrder do
  include LoaderMacro
  valid_password = 's<kY23653f,{9fcnshwq'
  invalid_password = 'invalid'
  error_message = 'message when errored'
  let (:params) { load_params('check_order.txt') }
  let (:good_params) { params.merge!(shopPassword: valid_password) }
  let (:bad_params) { params.merge!(shopPassword: invalid_password) }
  true_block = Proc.new { [true] }

  def notification(params, block)
    YandexKassaForm::Notification::CheckOrder.new params, &block
  end

  describe '.initialize' do
    it do
      expect do
        YandexKassaForm::Notification::CheckOrder.new good_params
      end.to raise_error ArgumentError
    end
  end

  describe '.code' do
    it { expect(notification(good_params, true_block).code).to be 0 }
    it { expect(notification(bad_params, true_block).code).to be 1 }
    
    context 'with an Order' do
      Order = Struct.new(:id, :sum)
      ORDERS = [Order.new(1, 87.10), Order.new(2, 10.10)]
      
      module Checker
        extend self
        def test_sum(params, order)
          res = order.sum == params[:orderSumAmount].to_f
          msg = res ? '' : 'errormsg'
          [res, msg]
        end
      end
      
      check_first = Proc.new { |params| Checker.test_sum(params, ORDERS.first) }
      check_second = Proc.new { |params| Checker.test_sum(params, ORDERS.last ) }
      
      it { expect(notification(good_params, check_first).code).to be 0 }
      it { expect(notification(good_params, check_second).code).to be 100 }
      it { expect(notification(good_params, check_second).message).to eq 'errormsg' }
    end
  end
end
