Given /^there are no (.*)s$/ do |model|
  Kernel.const_get(model.capitalize).delete_all
end

Then /^I should see the (\w+) registration form$/ do | formname |
  page.should have_css("form#new_#{formname}")
end

Then /^I should have (\d+) (\w+)$/ do |amount, model|
  if amount.to_i > 1
    model = model.singularize
  end
  Kernel.const_get(model.capitalize).count.should == amount.to_i
end