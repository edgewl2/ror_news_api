require "test_helper"

class Api::V1::Articles::SourcesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_articles_sources_index_url
    assert_response :success
  end

  test "should get show" do
    get api_v1_articles_sources_show_url
    assert_response :success
  end

  test "should get create" do
    get api_v1_articles_sources_create_url
    assert_response :success
  end

  test "should get update" do
    get api_v1_articles_sources_update_url
    assert_response :success
  end

  test "should get destroy" do
    get api_v1_articles_sources_destroy_url
    assert_response :success
  end
end
