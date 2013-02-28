include SpreeShipstation

module Spree
  class ShipstationController < Spree::StoreController
    ssl_required
    before_filter :authenticate

    DATE_FORMAT = "%m/%d/%Y %H:%M %Z"

    def export
      @shipments = Shipment.exportable
                           .between(date_param(:start_date),
                                    date_param(:end_date))
    end

    def shipnotify
      if Tracking.apply(params[:order_number],
                        params[:carrier],
                        params[:service],
                        params[:tracking_number])
        render text: 'success'
      else
        render text: 'failed', status: :bad_request
      end
    end

  protected
    def authenticate
      authenticate_or_request_with_http_basic do |username, password|
        username == Spree::Config[:shipstation_username] && password == Spree::Config[:shipstation_password]
      end
    end

    def date_param(name)
      Time.strptime(params[name] + " UTC", DATE_FORMAT)
    end
  end
end
