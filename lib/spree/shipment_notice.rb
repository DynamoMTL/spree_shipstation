module Spree
  class ShipmentNotice
    attr_reader :error

    def initialize(params, body)
      @id   = Hash.from_xml(body)["ShipNotice"]["OrderID"]
      @tracking = params[:tracking_number]
    end

    def apply
      locate ? update : not_found
    rescue => e
      handle_error(e)
    end

    private

    def locate
      @shipment = Spree::Shipment.find_by_id(@id)
    end

    def update
      @shipment.update_attribute(:tracking, @tracking)
      if @shipment.can_ship?
        unless @shipment.ship
          handle_error @shipment.inspect
        end
      end
      @error.blank?
    end

    def not_found
      @error = I18n.t(:shipment_not_found, number: @id)
      false
    end

    def handle_error(error)
      Rails.logger.error(error)
      @error = I18n.t(:import_tracking_error, error: error.to_s)
      false
    end
  end
end
