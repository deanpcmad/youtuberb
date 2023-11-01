require "test_helper"

class ClientTest < Minitest::Test
  def test_api_key
    client = YouTube::Client.new api_key: "abc123"
    assert_equal "abc123", client.api_key
  end

  def test_access_token
    client = YouTube::Client.new api_key: "abc123", access_token: "123abc"
    assert_equal "123abc", client.access_token
  end
end
