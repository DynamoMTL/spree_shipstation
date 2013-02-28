require 'spec_helper'

describe Spree::Shipment do
  context "between" do
    before do
      @active = []

      create_shipment(updated_at: Time.now - 1.days)
      create_shipment(updated_at: Time.now + 1.days)

      @active << create_shipment(updated_at: Time.now)
      @active << create_shipment(updated_at: Time.now)
    end

    subject { Spree::Shipment.between(Time.now-1.hour, Time.now + 1.hours) }

    specify { should have(2).shipment }

    specify { should == @active }
  end

  context "exportable" do
    let!(:pending) { create_shipment(state: 'pending') }
    let!(:ready)   { create_shipment(state: 'ready')   }
    let!(:shipped) { create_shipment(state: 'shipped') }

    subject { Spree::Shipment.exportable }

    specify { should have(2).shipments }

    specify { should include(ready)}
    specify { should include(shipped)}

    specify { should_not include(pending)}
  end

  def create_shipment(options={})
    Factory.create(:shipment, options).tap do |shipment|
      shipment.update_column(:state, options[:state]) if options[:state]
    end
  end
end
