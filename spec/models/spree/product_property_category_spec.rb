require 'spec_helper'

describe Spree::ProductPropertyCategory do
  it { should validate_presence_of :property_category }
  it { should validate_presence_of :product_property }
  it { should validate_presence_of :position }
end
