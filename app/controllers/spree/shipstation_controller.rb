include SpreeShipstation

module Spree
  class ShipstationController < BaseController
    include BasicSslAuthentication
    include Spree::DateParamHelper
    layout false

    protect_from_forgery except: :shipnotify

    def export
      @shipments = Spree::Shipment.order(:id)
                           .pending
                           .between(date_param(:start_date),
                                    date_param(:end_date))
                           .page(params[:page])
                           .per(50)
    end

    def shipnotify
      notice = Spree::ShipmentNotice.new(params, request.body.read)

      if notice.apply
        render(text: 'success')
      else
        render(text: notice.error, status: :bad_request)
      end
    end
  end
end
