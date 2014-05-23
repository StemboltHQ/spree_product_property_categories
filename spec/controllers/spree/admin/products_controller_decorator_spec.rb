require 'spec_helper'

describe Spree::Admin::ProductsController do
  stub_authorization!
  describe "PUT update" do
    context "with a product property" do
      let!(:product) { create :product }
      let(:attributes) {{
        use_route: :spree,
        id: product.to_param,
        clear_product_properties: true,
        product: {
          product_properties_attributes: property_attributes,
        }
      }}

      before { put :update, attributes }

      context "with a product property that has a category" do
        let(:property_attributes) {{
          "0" => {
            property_name: "test property",
            category_name: "test category",
            value: "1234"
          }
        }}


        it "responds successfully" do
          expect(response).to redirect_to(spree.edit_admin_product_path(product))
        end

        it "creates a product property with the appropriate category" do
          expect(assigns(:product).product_properties.last.category.name).to eql("test category")
        end
      end

      context "with a product property that has no category" do
        let(:property_attributes) {{
          "0" => {
            property_name: "test property",
            value: "1234"
          }
        }}

        it "responds successfully" do
          expect(response).to redirect_to(spree.edit_admin_product_path(product))
        end

        it "does not create a category with the product property" do
          expect(assigns(:product).product_properties.last.category).to be_nil
        end
      end
    end
  end
end
