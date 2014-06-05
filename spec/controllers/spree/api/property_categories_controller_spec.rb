require 'spec_helper'

describe Spree::Api::PropertyCategoriesController do
  before do
    allow(controller).to receive(:try_spree_current_user).and_return(create(:admin_user))
  end

  describe "GET index" do
    let!(:property_categories) do
      ["Newb", "New Hampshire", "Yolo"].map do |name|
        create :property_category, name: name
      end
    end

    let(:request) do
      {
        q: {
          name_cont: name_query
        },
        use_route: :spree,
        format: :json
      }
    end

    context "with a valid 'q' parameter" do
      let(:name_query) { "Ne" }
      before { get :index, request }

      it "returns the two entries with Ne in their name." do
        names = JSON.parse(response.body).map {|datum| datum["name"]}
        expect(names).to eql(["Newb", "New Hampshire"])
      end
    end

    context "without a 'q' parameter" do
     before { get :index, use_route: :spree, format: :json }

      it "returns all 3 property categories" do
        expect(JSON.parse(response.body)).to have(3).items
      end
    end
  end

  describe "POST update" do
    def self.assert_bad_response
      describe "response" do
        it "is a bad request" do
          expect(response.status).to eql(400)
        end

        it "returns a json hash with a flash key" do
          expect(JSON.parse(response.body).keys).to include("flash")
        end
      end
    end

    context "when a validation error occurs" do
      let(:product) { create :product }
      let(:request_double) do
        double("Spree::PropertyCategoryRequest", properties: [{}])
      end

      before do
        allow(Spree::PropertyCategoryRequest).to receive(:new).and_return(request_double)
        post :update, product_categories: [], product_id: product.slug, use_route: :spree, format: :json
      end

      assert_bad_response

      it "contains a validation error in its' response" do
        expect(response.body).to match(/Validation Failed/i)
      end
    end

    context "with a data parameter" do
      let(:request_params) do
        {
          "0" => {
            name: "test_category",
            position: 0,
            properties: {
              "0" => {
                key: "test_key",
                value: "test_value",
                measurement: ""
              }
            }
          },
          "1" => {
            name: "",
            position: 1,
            properties: {
              "0" => {
                key: "test",
                measurement: "",
                value: ""
              },
              "1" => {
                key: "",
                measurement: "",
                value: "test"
              }
            }
          }
        }
      end

      before { post :update, product_categories: request_params, product_id: product_slug, use_route: :spree, format: :json  }

      context "with a valid product_id parameter" do
        let!(:product) { create :product }
        let(:product_slug) { product.to_param }

        describe "response" do
          it "is successful" do
            expect(response).to be_success
          end

          it "returns a json hash with a flash key" do
            expect(JSON.parse(response.body).keys).to include("flash")
          end
        end

        describe "product properties" do
          subject { product.reload }

          it "created two product properties" do
            expect(subject.product_properties.count).to eql(2)
          end

          it "created one category" do
            # we don't create categories when they dont have names
            expect(Spree::PropertyCategory.count).to eql(1)
          end
        end
      end

      context "without a valid product_id parameter" do
        let(:product_slug) { nil }

        assert_bad_response
      end
    end

    context "without a data parameter" do
      before { post :update, format: :json, use_route: :spree }

      assert_bad_response
    end
  end
end
