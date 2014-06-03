require 'spec_helper'

describe Spree::PropertyCategory do
  it { should have_many(:product_properties) }
  it { should have_many(:product_property_categories) }
  it { should validate_presence_of(:name) }
end
