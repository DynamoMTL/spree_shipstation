require 'spec_helper'

include Spree

describe Spree::ShipmentNotice do
  let(:notice) { ShipmentNotice.new(order_number:    'S12345', 
                                    tracking_number: '1Z1231234') }

  context "#apply" do
    context "shipment found" do
      let(:shipment) { stub_model(Shipment, :shipped? => false) }

      before do
        Spree::Config.shipstation_number = :shipment
        Shipment.should_receive(:find_by_number).with('S12345').and_return(shipment)
        shipment.should_receive(:update_attribute).with(:tracking, '1Z1231234')
      end

      context "transition succeeds" do
        before do
          shipment.stub(:can_ship?) { true }
          shipment.should_receive(:ship) { true }
        end

        specify { notice.apply.should be_truthy }
      end

      context "transition fails" do
        before do
          shipment.stub(:can_ship?) { true }
          shipment.stub(:ship) { false }
          @result = notice.apply
        end

        specify { @result.should be_falsey }
        specify { notice.error.should_not be_blank }
      end
    end

    context "using order number instead of shipment number" do
      let(:shipment) { stub_model(Shipment, :shipped? => false) }
      let(:order)    { stub_model(Order, shipment: shipment) }

      before do
        Spree::Config.shipstation_number = :order
        Order.should_receive(:find_by_number).with('S12345').and_return(order)

        shipment.stub(:can_ship?) { true }
        shipment.should_receive(:ship) { true }
      end

      context "transition succeeds" do
        specify { notice.apply.should be_truthy }
      end
    end

    context "shipment not found" do
      before do
        Spree::Config.shipstation_number = :shipment
        Shipment.should_receive(:find_by_number).with('S12345').and_return(nil)
        @result = notice.apply
      end

      specify { @result.should be_falsey }
      specify { notice.error.should_not be_blank }
    end

    context "shipment already shipped" do
      let(:shipment) { stub_model(Shipment, :shipped? => true) }

      before do
        Spree::Config.shipstation_number = :shipment
        Shipment.should_receive(:find_by_number).with('S12345').and_return(shipment)
        shipment.should_receive(:update_attribute).with(:tracking, '1Z1231234')
      end

      specify { notice.apply.should be_truthy }
    end
  end
end
