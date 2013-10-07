include SpreeShipstation

module Spree
  class ShipstationController < Spree::BaseController
    layout false
    include BasicSslAuthentication
    include Spree::DateParamHelper


    skip_before_filter :verify_authenticity_token, only: :shipnotify

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
