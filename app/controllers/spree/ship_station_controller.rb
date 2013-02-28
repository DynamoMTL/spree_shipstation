module Spree
  class ShipStationController < Spree::StoreController
    ssl_required

    def export
    end

    def shipnotify
      render text: 'success'
    end
  end
end
