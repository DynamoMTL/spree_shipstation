include SpreeShipstation

module Spree
  class ShipstationController < Spree::StoreController
    include BasicSslAuthentication

    DATE_FORMAT = "%m/%d/%Y %H:%M %Z"

    def export
      @shipments = Shipment.exportable
                           .between(date_param(:start_date),
                                    date_param(:end_date))
    end

    def shipnotify
      notice = ShipmentNotice.new(params)

      if notice.apply
        render(text: 'success')
      else
        render(text: notice.error, status: :bad_request)
      end
    end

  private
    def date_param(name)
      Time.strptime(params[name] + " UTC", DATE_FORMAT)
    end
  end
end
