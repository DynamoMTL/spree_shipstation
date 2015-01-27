include SpreeShipstation

module Sprangular
  class ShipstationController < Sprangular::BaseController
    include Spree::BasicSslAuthentication
    include Spree::DateParamHelper

    def export
      @shipments = Spree::Shipment.exportable
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

