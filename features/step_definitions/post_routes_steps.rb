When /I visit (.*)/ do |route|
  visit(route)
end

Then /the page should redirect to (.*)/ do |path|
  page.current_path.should eq path
end

Then /the page should redirect matching (.*)/ do |regex|
  current_path.should match(regex)
end

Then /the page should respond with (\d+)/ do |response|
  page.status_code.should eq response.to_i
end