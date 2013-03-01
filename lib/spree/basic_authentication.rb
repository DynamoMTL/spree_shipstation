module Spree
  module BasicAuthentication
    extend ActiveSupport::Concern

    included do
      before_filter :authenticate
    end

  protected
    def authenticate
      authenticate_or_request_with_http_basic do |username, password|
        username == Config.shipstation_username && password == Config.shipstation_password
      end
    end
  end
end
