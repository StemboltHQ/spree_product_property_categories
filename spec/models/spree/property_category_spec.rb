require 'spec_helper'

describe Spree::PropertyCategory do
  it { should validate_presence_of(:name) }
end
