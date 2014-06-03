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
      let(:property) {{ display: "1", key: "hello", value: "world" }}

      context "with a property with a key and a value" do
        it "is formatted correctly" do
          expected = [{
            product: product,
            property_name: "hello",
            value: "world",
            position: 0,
            display: true,
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
    end
  end
end
