class Spree::PropertyCategory < ActiveRecord::Base
  has_many :product_properties, inverse_of: :category, foreign_key: "category_id"
  validates :name, presence: true
end
