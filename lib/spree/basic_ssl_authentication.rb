module Spree
  module BasicSslAuthentication
    extend ActiveSupport::Concern

    included do
      ssl_required
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
