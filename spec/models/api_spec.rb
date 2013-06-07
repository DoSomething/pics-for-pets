require 'spec_helper'

def build_key
  api = ApiKey.new
    api.key = 'aea12e3fe5f83f0d574fdff0342aba91'
  api.save

  api
end

describe ApiKey do
  it '1. Finds by id' do
    api = build_key()
    a = ApiKey.find_by_key(api.key)
    a.key.should eq 'aea12e3fe5f83f0d574fdff0342aba91'
  end
end