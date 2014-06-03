require 'spec_helper'

describe Spree::ProductProperty do
  it { should have_one(:property_category) }
  it { should have_one(:product_property_category) }
  subject { described_class.new }

  describe "#category_name" do
    context "without a category" do
      its(:category_name) { should be_nil }
    end

    context "with a category" do
      before do
        allow(subject).to receive(:property_category).
          and_return(double(name: "Hello World"))
      end

      its(:category_name) { should eql("Hello World") }
    end
  end

  describe "#valid?" do
    let!(:property) { build_stubbed :property }
    subject { described_class.new(attributes).valid? }

    let(:attributes) do
      {
        property: build_stubbed(:property),
        product: build_stubbed(:product),
        measurement_unit: mu,
        value: val
      }
    end

    context "With a 'none' measurement unit" do
      let(:mu) { "none" }

      context "with any value" do
        let(:val) { "shgs" }

        it { should be_true }
      end
    end

    context "With a valid measurement unit other than 'none'" do
      let(:mu) { "inches" }

      context "with a numeric value" do
        let(:val) { "54" }

        it { should be_true }
      end

      context "with any other value" do
        let(:val) { "hello world" }

        it { should be_false }
      end
    end

    context "With a invalid measurement unit" do
      let(:mu) { "cats" }

      context "with any value" do
        let(:val) { "hello" }

        it { should be_false }
      end
    end
  end
end
