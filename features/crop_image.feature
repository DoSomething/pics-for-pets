Feature: Crop image
	We need to be able to crop uploaded images into 1:1 aspect ratio

	@javascript
	Scenario: Upload image
	Given I am logged in
	When I visit /submit
	And I open the crop popup
	Then the page should show Squarify your image!

	When I click id crop-button
	Then the page should not have element #crop-overlay, #crop-container
	And the page should have element #preview-img-container