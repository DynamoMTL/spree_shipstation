Spree::Shipment.class_eval do
  def self.between(from, to)
    where('updated_at between ? and ?', from, to)
  end
end
