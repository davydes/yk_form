require 'spec_helper'
require 'nokogiri'

describe YandexKassaForm::Notification::CheckOrder do
  before { stub_const 'BODY_FILE', 'check_order.txt'}

  def notification(block)
    YandexKassaForm::Notification::CheckOrder.new request, &block
  end

  describe '.initialize' do
    it do
      expect do
        YandexKassaForm::Notification::CheckOrder.new request
      end.to raise_error ArgumentError
    end
  end

  describe '.code' do
    it { expect(notification(TRUE_PROC).code).to be 0 }
    it do
      stub_const('PASSWORD', PASSWORD_INVALID)
      expect(notification(TRUE_PROC).code).to be 1
    end
    
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
      
      it { expect(notification(check_first).code).to be 0 }
      it { expect(notification(check_second).code).to be 100 }
      it { expect(notification(check_second).message).to eq 'errormsg' }
    end
   
    context 'when block has exception' do
      block = lambda { |params| raise StandartError }
      it { expect(notification(block).code).to be 100 }
    end
  end
end
