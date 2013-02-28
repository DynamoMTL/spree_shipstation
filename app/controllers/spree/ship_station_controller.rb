module Spree
  class ShipStationController < Spree::StoreController
    def export
    end

    def shipnotify
      render text: 'success'
    end
  end
end
