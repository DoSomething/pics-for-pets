require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  setup do
    @post = posts(:one)
  end

  test "should get index" do
    get :index
    assert_response 302
    assert_redirected_to :login
    #assert_not_nil assigns(:posts)
  end
end
