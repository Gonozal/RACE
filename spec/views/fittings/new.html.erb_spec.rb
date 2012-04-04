require 'spec_helper'

describe "fittings/new" do
  before(:each) do
    assign(:fitting, stub_model(Fitting).as_new_record)
  end

  it "renders new fitting form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => fittings_path, :method => "post" do
    end
  end
end
