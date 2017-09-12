require 'test_helper'

class SubDomainsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get sub_domains_index_url
    assert_response :success
  end

  test "should get create" do
    get sub_domains_create_url
    assert_response :success
  end

  test "should get new" do
    get sub_domains_new_url
    assert_response :success
  end

end
