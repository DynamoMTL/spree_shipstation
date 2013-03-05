require 'spec_helper'

include Spree

describe Spree::ShipmentNotice do
  let(:notice) { ShipmentNotice.new(order_number:    'S12345', 
                                    tracking_number: '1Z1231234') }

  context "#apply" do
    context "shipment found" do
      let(:shipment) { mock_model(Shipment, can_ship?: true) }

      before do
        Shipment.should_receive(:find_by_number).with('S12345').and_return(shipment)
        shipment.should_receive(:update_attribute).with(:tracking, '1Z1231234')
      end

      context "transition succeeds" do
        before  { shipment.should_receive(:update_attribute).with(:state, 'shipped') }

        specify { notice.apply.should be_true }
      end

      context "transition fails" do
        before  do
          shipment.should_receive(:update_attribute)
                  .with(:state, 'shipped')
                  .and_raise('oopsie')
          @result = notice.apply
        end

        specify { @result.should be_false }
        specify { notice.error.should_not be_blank }
      end
    end

    context "shipment not found" do
      before do
        Shipment.should_receive(:find_by_number).with('S12345').and_return(nil)
        @result = notice.apply
      end

      specify { @result.should be_false }
      specify { notice.error.should_not be_blank }
    end

    context "shipment already shipped" do
      let(:shipment) { mock_model(Shipment, 'can_ship?' => false) }

      before do
        Shipment.should_receive(:find_by_number).with('S12345').and_return(shipment)
        shipment.should_receive(:update_attribute).with(:tracking, '1Z1231234')
        shipment.should_not_receive(:ship!)
      end

      specify { notice.apply.should be_true }
    end
  end
end
