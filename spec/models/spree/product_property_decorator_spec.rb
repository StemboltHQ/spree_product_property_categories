require 'spec_helper'

describe Spree::ProductProperty do
  it { should belong_to(:category) }
  let!(:instance) { described_class.new }

  describe ".for_category" do
    let!(:property) { create :product_property, category_id: 100 }
    let!(:other_property) { create :product_property, category_id: 88 }
    let(:category_double) { double("Spree::PropertyCategory", id: 100) }

    subject { described_class.for_category(category_double) }

    it "contains the properties that have the supplied category" do
      expect(subject).to include(property)
    end

    it "doesnt contain properties that dont have the category" do
      expect(subject).to_not include(other_property)
    end
  end

  describe "#category_name=" do
    subject { instance.category_name = cat_name }

    context "with a blank name" do
      let(:cat_name) { nil }

      it "does not assign a category" do
        subject
        expect(instance.category_id).to be_nil
      end
    end

    context "with a non blank name" do
      let(:cat_name) { "spree123" }

      context "with an existing property category by the same name" do
        let!(:category) { Spree::PropertyCategory.create!(name: cat_name) }

        it "assigns the category to the existing property category"  do
          subject
          expect(instance.category_id).to eql(category.id)
        end
      end

      context "with no existing property category by the same name" do
        it "creates the category if its needed" do
          subject
          expect(instance.category.name).to eql(cat_name)
        end
      end
    end
  end
end
