module Spree
  class ShipmentNotice
    attr_reader :error

    def initialize(params) 
      @number   = params[:order_number]
      @tracking = params[:tracking_number]

      @shipment = Shipment.find_by_number(@number)
    end

    def apply
      if @shipment
        @shipment.update_attribute(:tracking, @tracking)
        @shipment.ship! if @shipment.can_ship?

        true
      else
        @error = I18n.t(:shipment_not_found, number: @number)
        false
      end
    end
  end
end
