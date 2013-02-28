Spree::Shipment.class_eval do
  scope :exportable, where('state != ?', 'pending')

  def self.between(from, to)
    where('updated_at between ? and ?', from, to)
  end
end
