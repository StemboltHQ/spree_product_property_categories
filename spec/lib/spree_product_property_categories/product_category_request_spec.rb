require 'spec_helper'
require 'spree_product_property_categories/property_category_request'

describe Spree::PropertyCategoryRequest do
  describe "#properties" do
    let(:product) { build_stubbed :product }
    let(:request) do
      {
        "0" => {
          name: category_name,
          position: 0,
          properties: category_properties
        }
      }
    end

    subject { described_class.new(request, product).properties }

    context "with an empty request" do
      let(:request) { {} }
      it { should be_empty }
    end

    context "with a request containing a category without properties" do
      let(:category_name) { nil }
      let(:category_properties) { nil }
      it { should be_empty }
    end

    context "with a request containing a category with properties" do
      let(:category_name) { "not null" }
      let(:category_properties) {{"0" => property }}
      let(:property) {{ key: "hello", value: "world" }}

      context "with a property with a key and a value" do
        it "is formatted correctly" do
          expected = [{
            product: product,
            property_name: "hello",
            value: "world",
            position: 0,
            product_property_category_attributes: {
              position: 0,
              property_category_attributes: { name: "not null" }
            }
          }]
          expect(subject).to eql(expected)
        end
      end

      context "with a property with a key and no value" do
        let(:property) {{ key: 'hello', value: nil }}

        it "has the correct key" do
          expect(subject.first[:property_name]).to eql("hello")
        end

        it "has no value" do
          expect(subject.first[:value]).to be_nil
        end
      end

      context "with a property with no key" do
        let(:property) { {key: nil} }
        it { should be_empty }
      end

      context "without a category name" do
        let(:category_name) { nil }
        it "sets nil categories to 'Uncategorized'" do
          expect(subject.first[:product_property_category_attributes][:property_category_attributes][:name]).to eql("Uncategorized")
        end
      end
    end
  end
end
