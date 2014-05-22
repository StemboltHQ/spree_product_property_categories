class Spree::PropertyCategory < ActiveRecord::Base
  validates :name, presence: true
end
