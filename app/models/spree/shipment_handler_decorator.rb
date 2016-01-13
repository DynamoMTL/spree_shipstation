Spree::ShipmentHandler.class_eval do
  private
    def send_shipped_email
      Spree::ShipmentMailer.shipped_email(@shipment.id).deliver if Spree::Config.send_shipped_email
    end
end
