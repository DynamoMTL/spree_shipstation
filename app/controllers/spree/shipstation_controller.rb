include SpreeShipstation

module Spree
  class ShipstationController < Spree::StoreController
    include BasicAuthentication
    ssl_required

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

  private
    def date_param(name)
      Time.strptime(params[name] + " UTC", DATE_FORMAT)
    end
  end
end
