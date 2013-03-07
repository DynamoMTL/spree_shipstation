Spree::Shipment.class_eval do
  scope :exportable, where('state != ?', 'pending')

  def self.between(from, to)
    where(updated_at: from..to)
  end

private
  def send_shipped_email
    ShipmentMailer.shipped_email(self).deliver if Spree::Config.send_shipped_email
  end
end
