require File.dirname(__FILE__) + '/../test_helper'
require 'articles_controller'

# Re-raise errors caught by the controller.
class ArticlesController; def rescue_action(e) raise e end; end

class ArticlesControllerTest < Test::Unit::TestCase
  fixtures :articles

  def setup
    @controller = ArticlesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:articles)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_articles
    old_count = Articles.count
    post :create, :articles => { }
    assert_equal old_count+1, Articles.count
    
    assert_redirected_to articles_path(assigns(:articles))
  end

  def test_should_show_articles
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_articles
    put :update, :id => 1, :articles => { }
    assert_redirected_to articles_path(assigns(:articles))
  end
  
  def test_should_destroy_articles
    old_count = Articles.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Articles.count
    
    assert_redirected_to articles_path
  end
end
