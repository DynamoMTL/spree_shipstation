module Spree
  module DateParamHelper
    DATE_FORMAT = "%m/%d/%Y %H:%M %Z"

  private
    def date_param(name)
      Time.strptime(params[name] + " PDT", DATE_FORMAT)
    end
  end
end
