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
      end
    end
  end
end
