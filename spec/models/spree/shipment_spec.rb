require 'spec_helper'

describe Spree::Shipment do
  context "between" do
    before do
      @active = []

      Timecop.freeze(1.day.ago) do
        create :shipment
      end

      Timecop.freeze(1.day.from_now) do
        create :shipment
      end

      # Old shipment thats order was recently updated..
      Timecop.freeze 1.week.ago do
        @shipment = create(:shipment)
      end
      @shipment.order = create(:order)
      @shipment.save

      @active << @shipment

      @active << create(:shipment)
      @active << create(:shipment)
    end

    subject { Spree::Shipment.between(Time.now-1.hour, Time.now + 1.hours) }

    specify { expect(subject.count).to eq(3) }

    specify { should == @active }
  end

  context "exportable" do
    let!(:pending) { create :shipment, state: 'pending' }
    let!(:ready)   { create :shipment, state: 'ready'   }
    let!(:shipped) { create :shipment, state: 'shipped' }

    subject { Spree::Shipment.ready }

    specify { expect(subject.count).to eq(2) }

    specify { should include(ready)}
    specify { should include(shipped)}

    specify { should_not include(pending)}
  end

  context "shipped_email" do
    let(:shipment) { create :shipment, state: 'ready' }

    context "enabled" do
      it "sends email" do
        Spree::Config.send_shipped_email = true
        mail_message = double "Mail::Message"
        Spree::ShipmentMailer.should_receive(:shipped_email).with(shipment).and_return mail_message
        mail_message.should_receive :deliver
        shipment.ship!
      end
    end

    context "disabled" do
      it "doesnt send email" do
        Spree::Config.send_shipped_email = false
        Spree::ShipmentMailer.should_not_receive(:shipped_email)
        shipment.ship!
      end
    end
  end
end
