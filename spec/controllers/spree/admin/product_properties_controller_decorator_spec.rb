require 'spec_helper'

describe Spree::Admin::ProductPropertiesController do
  stub_authorization!

  describe "GET index" do
    describe "assigns(:categories)" do
      let!(:product) { create :product }
      let!(:property) { create :product_property, product: product, category: category }

      before do
        get :index, product_id: product.to_param, use_route: :spree
      end

      subject { assigns(:categories).to_a }

      context "when product properties exist with categories" do
        let(:category) { Spree::PropertyCategory.create!(name: "sups") }

        it "contains those categories" do
          expect(subject).to eql([category])
        end
      end

      context "when product properties dont exist or are without categories" do
        let(:category) { nil }

        it "is empty" do
          expect(subject).to be_empty
        end
      end
    end
  end
end
