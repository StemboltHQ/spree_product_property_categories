require 'spec_helper'

describe Spree::PropertyCategory do
  it { should have_many(:product_properties).with_foreign_key('category_id') }
  it { should validate_presence_of(:name) }
end
