require 'spec_helper'

describe Spree::PropertyCategory do
  it { should have_many(:product_properties) }
  it { should have_many(:product_property_categories) }
  it { should validate_presence_of(:name) }

  describe ".for_products" do
    let!(:product) { create :product }
    let!(:product_property) { create :product_property, product: product }
    let!(:property_category) { create :property_category }
    let!(:other_category) { create :property_category }
    before do
      product_property.property_category = property_category
      product_property.save!
    end

    subject { described_class.for_products([product]) }

    it "returns only the categories tied to the products indicated" do
      expect(subject.to_a).to eql([property_category])
    end
  end
end
