Spree::Core::Engine.routes.draw do
  namespace :api do
    post "/property_categories", to: "property_categories#update", as: :update_property_categories
    get "/property_categories", to: "property_categories#index", as: :property_categories
  end
end
