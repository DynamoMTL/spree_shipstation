# HACK ALERT
# Shipstation uses a query string parameter called "action", 
# Rails already uses that for something else.. 
# This rack app maps the "action" parameter to the actual controller action name
class MapQueryStringApp
  def self.call(env)
    controller_name = 'spree/shipstation_controller'
    query           = Rack::Utils.parse_nested_query(env['QUERY_STRING'])
    action          = query['action'] || :index

    controller = controller_name.classify.constantize
    controller.action(action).call(env)
  end
end
