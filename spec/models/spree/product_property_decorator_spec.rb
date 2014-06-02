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
end
