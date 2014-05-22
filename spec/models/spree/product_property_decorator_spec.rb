require 'spec_helper'

describe Spree::ProductProperty do
  it { should belong_to(:category) }
end
