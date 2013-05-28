require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  setup do
    @post = posts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:posts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create post" do
    assert_difference('Post.count') do
      post :create, post: { adopted: @post.adopted, bottom_text: @post.bottom_text, creation_time: @post.creation_time, flagged: @post.flagged, image: @post.image, name: @post.name, promoted: @post.promoted, share_count: @post.share_count, shelter: @post.shelter, state: @post.state, story: @post.story, top_text: @post.top_text, animal_type: @post.type, update_time: @post.update_time }
    end

    assert_redirected_to post_path(assigns(:post))
  end

  test "should show post" do
    get :show, id: @post
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @post
    assert_response :success
  end

  test "should update post" do
    put :update, id: @post, post: { adopted: @post.adopted, bottom_text: @post.bottom_text, creation_time: @post.creation_time, flagged: @post.flagged, image: @post.image, name: @post.name, promoted: @post.promoted, share_count: @post.share_count, shelter: @post.shelter, state: @post.state, story: @post.story, top_text: @post.top_text, animal_type: @post.type, update_time: @post.update_time }
    assert_redirected_to post_path(assigns(:post))
  end

  test "should destroy post" do
    assert_difference('Post.count', -1) do
      delete :destroy, id: @post
    end

    assert_redirected_to posts_path
  end
end
