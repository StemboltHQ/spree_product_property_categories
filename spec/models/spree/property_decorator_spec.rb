require 'spec_helper'

describe Spree::Property do
  describe ".uncategorized_for_products" do
    let!(:product) { create :product }
    let!(:product_property) { create :product_property, product: product }
    let!(:categorized_property) { create :product_property, product: product }
    let!(:other_property) { create :product_property }
    let!(:expected_property) { product_property.property }

    subject { described_class.uncategorized_for_products([product.id]) }

    before do
      categorized_property.property_category = create(:property_category, name: "rasfasd")
      categorized_property.save!
    end

    it "only returns the expected property" do
      expect(subject.to_a).to eql([expected_property])
    end
  end

  describe ".for_products" do
    let!(:product) { create :product }
    let!(:product_property) { create :product_property, product: product }
    let!(:other_property) { create :product_property }
    let!(:expected_property) { product_property.property }

    subject { described_class.for_products([product.id]) }

    it "only returns the expected property" do
      expect(subject.to_a).to eql([expected_property])
    end
  end
end
