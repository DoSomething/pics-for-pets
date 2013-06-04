Given /we visited ([A-z]*)/ do |action|
  visit(action.to_sym)
end

Then /the page should redirect to (.*)/ do |greeting|
  expect(response).to redirect_to greeting.to_sym
end