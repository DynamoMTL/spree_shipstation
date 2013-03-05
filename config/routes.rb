Spree::Core::Engine.routes.draw do
  get  '/shipstation' => MapQueryStringApp
  post '/shipstation' => MapQueryStringApp
end
