require 'spec_helper'

describe Spree::ShipstationController, type: :controller do
  before do
    controller.stub(check_authorization: false, spree_current_user: FactoryGirl.create(:user))
    @request.accept = 'application/xml'
  end

  context "logged in" do
    before { login }

    context "export" do
      let(:shipments) { double }

      before do
        Spree::Shipment.stub_chain(:pending, :between).with(Time.new(2013, 12, 31,  8, 0, 0, "+00:00"),
                                                               Time.new(2014,  1, 13, 23, 0, 0, "+00:00"))
                                                         .and_return(shipments)
        shipments.stub_chain(:page, :per).and_return(:some_shipments)

        get :export, start_date: '12/31/2013 8:00', end_date: '1/13/2014 23:00', use_route: :spree
      end

      specify { response.should be_success }
      specify { assigns(:shipments).should == :some_shipments}
    end

    context "shipnotify" do
      let(:notice) { double(:notice) }

      before do
        Spree::ShipmentNotice.should_receive(:new)
                             .with(hash_including(order_number: 'S12345'), "order_number=S12345")
                             .and_return(notice)
      end

      context "shipment found" do
        before do
          notice.should_receive(:apply).and_return(true)

          post :shipnotify, order_number: 'S12345', use_route: :spree
        end

        specify { response.should be_success }
        specify { response.body.should =~ /success/ }
      end

      context "shipment not found" do
        before do
          notice.should_receive(:apply).and_return(false)
          notice.should_receive(:error).and_return("failed")

          post :shipnotify, order_number: 'S12345', use_route: :spree
        end

        specify { response.code.should == '400' }
        specify { response.body.should =~ /failed/ }
      end
    end

    it "doesnt know unknown" do
      expect { post :unknown, use_route: :spree }.to raise_error(AbstractController::ActionNotFound)
    end
  end

  context "not logged in" do
    it "returns error" do
      get :export, use_route: :spree

      response.code.should == '401'
    end
  end

  def login
    config(username: "mario", password: 'lemieux')

    user, pw = 'mario', 'lemieux'
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user,pw)
  end

  def config(options = {})
    options.each do |k, v|
      Spree::Config.send("shipstation_#{k}=", v)
    end
  end
end
