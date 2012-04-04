require 'spec_helper'

describe "fittings/index" do
  before(:each) do
    assign(:fittings, [
      stub_model(Fitting),
      stub_model(Fitting)
    ])
  end

  it "renders a list of fittings" do
    render
  end
end
