require 'spec_helper'

def build_post
  post = Post.new
    post.uid = 778374
    post.adopted = false
    post.bottom_text = 'Bottom text'
    post.flagged = false
    post.image = File.new(Rails.root + 'spec/mocks/ruby.png')
    post.name = 'Spot the test'
    post.promoted = false
    post.share_count = 0
    post.shelter = 'Cats'
    post.state = 'PA'
    post.story = "This is a story"
    post.animal_type = 'cat'
  post.save!

  post
end

describe Post do
  it '1. creates' do
    post = build_post()

    post.id.should_not == nil
  end

  it '2. finds by id' do
    post = build_post()
    p = Post.find_by_id(post.id)
    p.uid.should eq 778374
  end

  it '3. Deletes' do
    post = build_post()

    po = Post.find_by_id(post.id)
    Post.destroy po

    again = Post.find_by_id(post.id)
    again.should eq nil
  end
end