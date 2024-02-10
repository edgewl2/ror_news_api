require "test_helper"

class Api::V1::ArticlesControllerTest < ActionDispatch::IntegrationTest

  setup do
    @article = articles(:two)
  end

  teardown do
    Rails.cache.clear
  end

  test "should get from index a article list as json" do
    get api_v1_articles_url
    response_values = JSON.parse(@response.body)
    assert_equal "index", @controller.action_name
    assert_equal 2, response_values.size
    assert_equal "application/json", @response.media_type
    assert_equal 200, @response.status
    assert_response :success
  end

  test "should get from show only one article as json" do
    get api_v1_article_url(@article)
    response_values = JSON.parse(@response.body)
    assert_equal "show", @controller.action_name
    assert_equal "application/json", @response.media_type
    assert_equal @article.title, response_values['title']
    assert_equal 200, @response.status
    assert_response :success
  end

  test "should destroy an article" do
    assert_difference("Article.count", -1) do
      delete api_v1_article_url(@article)
    end
    assert_equal 204, @response.status
    assert_response :success
  end

  test "should update an article" do
    put api_v1_article_url(@article), params: { article: { title: "MyString2" } }
    @article.reload
    assert_equal "MyString2", @article.title
    assert_equal 202, @response.status
    assert_response :success
  end

end
