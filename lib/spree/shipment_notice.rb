module Spree
  class ShipmentNotice
    attr_reader :error

    def initialize(params) 
      @number   = params[:order_number]
      @tracking = params[:tracking_number]
    end

    def apply
      locate ? update : not_found
    rescue => e
      handle_error(e)
    end

  private
    def locate
      @shipment = Shipment.find_by_number(@number)
    end

    def update
      @shipment.update_attribute(:tracking, @tracking)
      @shipment.ship! if @shipment.can_ship?

      true
    end

    def not_found
      @error = I18n.t(:shipment_not_found, number: @number)
      false
    end
    
    def handle_error(error)
      Rails.logger.error(error)
      @error = I18n.t(:import_tracking_error, error: error.to_s)
      false
    end
  end
end
