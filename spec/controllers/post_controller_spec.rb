require 'spec_helper'

describe PostsController, :type => :controller do
  describe 'GET #index' do
    it 'redirects to login' do
      get :index
      expect(response).to redirect_to :login
    end

    it 'shows index' do
      get :index, :bypass => true

      expect(response).to be_success
      expect(response.status).to eq 200
      expect(response).to render_template 'index'
    end
  end

  describe 'GET #filter' do
    it 'redirects to login' do
      get :filter, :run => 'my'
      expect(response).to redirect_to :login
    end

    it 'show filter' do
      get :filter, :run => 'animal', :atype => 'cats', :bypass => true
      expect(response).to be_success
      expect(response.status).to eq 200
      expect(response).to render_template 'filter'
    end
  end

  describe 'GET #new' do
    it 'redirects to login' do
      get :new
      expect(response).to redirect_to :login
    end

    it 'shows submit' do
      get :new, :bypass => true
      expect(response).to be_success
      expect(response.status).to eq 200
      expect(response).to render_template 'new'
    end
  end
end