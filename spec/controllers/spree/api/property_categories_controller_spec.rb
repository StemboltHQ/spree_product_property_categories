require 'spec_helper'

describe Spree::Api::PropertyCategoriesController do
  describe "POST update" do
    before do
      allow(controller).to receive(:try_spree_current_user).and_return(create(:admin_user))
    end

    context "with a data parameter" do
      let(:request_params) do
        {
          "0" => {
            name: "test_category",
            properties: {
              "0" => {
                key: "test_key",
                value: "test_value"
              }
            }
          },
          "1" => {
            name: "",
            properties: {
              "0" => {
                key: "test",
                value: ""
              },
              "1" => {
                key: "",
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
          it "is a successful" do
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

          it "created two categories" do
            expect(Spree::PropertyCategory.count).to eql(2)
          end
        end
      end

      context "without a valid product_id parameter" do
        let(:product_slug) { nil }

        describe "response" do
          it "is a bad request" do
            expect(response.status).to eql(400)
          end

          it "returns a json hash with a flash key" do
            expect(JSON.parse(response.body).keys).to include("flash")
          end
        end
      end
    end

    context "without a data parameter" do
      before { post :update, format: :json, use_route: :spree }

      describe "response" do
        it "is a bad request" do
          expect(response.status).to eql(400)
        end

        it "returns a json hash with a flash key" do
          expect(JSON.parse(response.body).keys).to include("flash")
        end
      end
    end
  end
end