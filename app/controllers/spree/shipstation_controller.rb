include SpreeShipstation

module Spree
  class ShipstationController < Spree::StoreController
    include BasicSslAuthentication
    include Spree::DateParamHelper

    def export
      @shipments = Spree::Shipment.exportable.international
                           .between(date_param(:start_date),
                                    date_param(:end_date))
                           .page(params[:page])
                           .per(50)
    end

    def shipnotify
      notice = Spree::ShipmentNotice.new(params)

      if notice.apply
        render(text: 'success')
      else
        render(text: notice.error, status: :bad_request)
      end
    end
  end
end
