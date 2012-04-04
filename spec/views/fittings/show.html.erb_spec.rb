require 'spec_helper'

describe "fittings/show" do
  before(:each) do
    @fitting = assign(:fitting, stub_model(Fitting))
  end

  it "renders attributes in <p>" do
    render
  end
end
