module Spree
  class ShipstationController < Spree::StoreController
    ssl_required

    DATE_FORMAT = "%m/%d/%Y %H:%M"

    def export
      @shipments = Shipment.exportable
                           .between(date_param(:start_date),
                                    date_param(:end_date))
    end

    def shipnotify
      render text: 'success'
    end

  private
    def date_param(name)
      Time.strptime(params[name], DATE_FORMAT)
    end
  end
end
