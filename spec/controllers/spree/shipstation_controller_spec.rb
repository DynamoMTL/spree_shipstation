require 'spec_helper'

describe Spree::ShipstationController do
  before do
    controller.stub(check_authorization: false, spree_current_user: FactoryGirl.create(:user))
    @request.accept = 'application/xml'
  end

  context "logged in" do
    before { login }

    context "export" do
      before do
        Spree::Shipment.stub_chain(:exportable, :between).with(Time.new(2013, 12, 31,  8, 0, 0, "+00:00"),
                                                               Time.new(2014,  1, 13, 23, 0, 0, "+00:00"))
                                                         .and_return(:some_shipments)

        get :export, start_date: '12/31/2013 8:00', end_date: '1/13/2014 23:00', use_route: :spree
      end

      specify { response.should be_success }
      specify { assigns(:shipments).should == :some_shipments}
    end

    context "shipnotify" do
      context "shipment found" do
        before do
          SpreeShipstation::Tracking.should_receive(:apply).with('S12345', 'UPS', 'Next Day', '1Z123123123123').and_return(true)

          get :shipnotify, order_number:    'S12345',
                           carrier:         'UPS',
                           service:         'Next Day',
                           tracking_number: '1Z123123123123',
                           use_route: :spree
        end

        specify { response.should be_success }
        specify { response.body.should =~ /success/ }
      end

      context "shipment not found" do
        before do
          SpreeShipstation::Tracking.should_receive(:apply)
                                    .and_return(false)

          get :shipnotify, use_route: :spree
        end

        specify { response.code.should == '400' }
        specify { response.body.should =~ /failed/ }
      end
    end

    it "doesnt know unknown" do
      expect { get :unknown, use_route: :spree }.to raise_error(AbstractController::ActionNotFound)
    end
  end

  context "not logged in" do
    it "returns error" do
      get :export, use_route: :spree

      response.code.should == '401'
    end
  end

  def login
    user = 'mario'
    pw   = 'lemieux'
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user,pw)
  end
end
