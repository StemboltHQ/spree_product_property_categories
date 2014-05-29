Spree::Core::Engine.routes.draw do
  namespace :api do
    post "/property_categories", to: "property_categories#update", as: :property_categories
  end
end
