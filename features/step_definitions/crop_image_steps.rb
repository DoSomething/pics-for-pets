When /I open the crop popup/ do
  within '.form-submit' do
    find(:id, 'post_image').click
    find(:id, 'post_image').set Rails.root.to_s + '/spec/mocks/ruby.png'
    find(:id, 'post_image').click
  end
end

Then /the page should not have element (.+)/ do |elements|
	elements.split(", ").each do |element|
		page.should have_no_selector(:css_selector, element)
	end
end

Then /the page should have element (.+)/ do |elements|
	elements.split(", ").each do |element|
		page.should have_selector(:css_selector, element)
	end
end

Then /image field should be set to ruby.png/ do
	find(:id, 'post_image').value.should eq Rails.root.to_s + '/spec/mocks/ruby.png'
end

Then /image field should not be set/ do
	find(:id, 'post_image').value.should eq ""
end