require 'spec_helper'

describe Spree::Shipment do
  context "between" do
    before do
      @active = []

      Factory.create(:shipment, updated_at: Time.now - 1.days)
      Factory.create(:shipment, updated_at: Time.now + 1.days)

      @active << Factory.create(:shipment, updated_at: Time.now)
      @active << Factory.create(:shipment, updated_at: Time.now)
    end

    subject { Spree::Shipment.between(Time.now-1.hour, Time.now + 1.hours) }

    specify { should have(2).shipment }

    specify { should == @active }
  end
end
