require 'spec_helper'

describe Spree::ShipStationController do
  before do
    controller.stub(check_authorization: false, spree_current_user: FactoryGirl.create(:user))
    @request.accept = 'application/xml'
  end

  context "export" do
    before do
      get :export, use_route: :spree
    end

    specify { response.should be_success }
  end

  context "shipnotify" do
    before do
      get :shipnotify, use_route: :spree
    end

    specify { response.should be_success }
    specify { response.body.should =~ /success/ }
  end
end
