require 'spec_helper'

describe Category do
  it {should have_many(:leagues)}
  it {should have_many(:questions)}
end
