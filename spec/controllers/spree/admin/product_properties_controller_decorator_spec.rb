require 'spec_helper'

describe Spree::Admin::ProductPropertiesController do
  stub_authorization!

  describe "GET index" do
    let!(:product) { create :product }

    describe "response" do
      before do
        get :index, product_id: product.to_param, use_route: :spree
      end

      it "is successful" do
        expect(response).to be_success
      end

      it "renders the index action" do
        expect(response).to render_template(:index)
      end
    end

    describe "assigns(:data)" do
      subject { JSON.parse(assigns(:data), symbolize_names: true) }

      context "with no product properties" do
        it "is an empty json array" do
          get :index, product_id: product.to_param, use_route: :spree
          expect(subject).to be_empty
        end
      end

      context "with product properties that have a category" do
        let!(:property) { create :product_property, product: product, category: category }
        let!(:category) { Spree::PropertyCategory.create(name: "test") }
        let(:expected) do
          [
            {
              name: "test",
              properties: [{
                key: property.property_name,
                value: property.value
              }]
            }
          ]
        end

        it "has the correct format" do
          get :index, product_id: product.to_param, use_route: :spree
          expect(subject).to eql(expected)
        end
      end

      context "with product properties that have no category" do
        let!(:property) { create :product_property, product: product, category: nil }
        let(:expected) do
          [
            {
              name: "uncategorized",
              properties: [{
                key: property.property_name,
                value: property.value
              }]
            }
          ]
        end

        it "sets a category name of 'uncategorized' and is included in the result" do
          pending "not implimented yet"
          get :index, product_id: product.to_param, use_route: :spree
          expect(subject).to eql(expected)
        end
      end
    end
  end
end
