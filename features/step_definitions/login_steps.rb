Given /^the following (.+) records?$/ do |factory, table|
  table.hashes.each do |hash|
    Factory(factory, hash)
  end
end

Then /^I should see the edit (\w+) form$/ do |type|
  page.should have_css("form.#{type}")
end