require 'spec_helper'

describe "fittings/edit" do
  before(:each) do
    @fitting = assign(:fitting, stub_model(Fitting))
  end

  it "renders the edit fitting form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => fittings_path(@fitting), :method => "post" do
    end
  end
end
