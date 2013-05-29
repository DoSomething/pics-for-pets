require 'spec_helper'

describe 'sign up', :type => :feature, :js => true do
  it 'signs me in' do
    visit '/'
    page.should have_content('Already have an account?')

    click_link 'log in'
    page.should have_content 'Not a DoSomething.org member?'

    within '.form-login' do
      find(:id, 'session_username').set 'mchitten@gmail.com'
      find(:id, 'session_password').set 'h4dlj6pTr'
      click_button 'submit'
    end

    page.should have_content 'TYPE OF PET'
  end
end

describe 'submit flow', :type => :feature, :js => true do
  before :each do
    visit '/'
    page.should have_content('Already have an account?')

    click_link 'log in'
    page.should have_content 'Not a DoSomething.org member?'

    within '.form-login' do
      find(:id, 'session_username').set 'bohemian_test'
      find(:id, 'session_password').set 'bohemian_test'
      click_button 'submit'
    end
  end

  it 'submits' do
    visit '/submit'
    form = find(:class, '.form-submit')
    form.should have_content 'UPLOAD AN IMAGE'
    form.should_not have_content 'Top text'
    form.should_not have_content 'Bottom text'

    within '.form-submit' do
      find(:id, 'post_image').click
      find(:id, 'post_image').set Rails.root.to_s + '/spec/mocks/ruby.png'
      find(:id, 'post_image').click

      form.should have_content 'Top text'
      form.should have_content 'Bottom text'

      find(:id, 'post_top_text').set 'Top text'
      find(:id, 'post_bottom_text').set 'Bottom text'

      find(:id, 'post_name').set 'Spot'
      find(:xpath, '//*[@id="post_animal_type"]/option[2]').click
      find(:id, 'post_shelter').set 'Shelter'
      find(:xpath, '//*[@id="post_state"]/option[16]').click

      page.save_screenshot 'spec/images/screen.jpg'

      click_button 'Submit'
    end

    page.should have_content 'Spot'
  end

  it 'xfilters' do
    visit '/cats-ID'
    page.should have_content 'Spot, ID'

    visit '/cats'
    page.should have_content 'Spot, ID'

    visit '/ID'
    page.should have_content 'Spot, ID'

    visit '/cats-CA'
    page.should have_content 'Oh, shit'

    visit '/CA'
    page.should have_content 'Oh, shit'
  end
end