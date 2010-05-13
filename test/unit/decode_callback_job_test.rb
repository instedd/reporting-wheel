require 'test_helper'
require 'mocha'

class DecodeCallbackJobTest < ActiveSupport::TestCase
  
  def setup
    @url = 'http://www.domain.com/some/url'
    @body = 'Post Body Content'
    @query_parameters = {:key1 => 'value1', :key2 => 'value2'}
    
    @job = DecodeCallbackJob.new @url, @body, @query_parameters
  end
  
  test "should return url" do
    assert_equal @url, @job.url
  end
  
  test "should return body" do
    assert_equal @body, @job.body
  end
  
  test "should return query parameters" do
    assert_equal @query_parameters, @job.query_parameters
  end
  
  test "should perform a post" do
    request = mock('Net::HTTPRequest')
    response = mock('Net::HTTPResponse')
      
    Net::HTTP.expects(:new).with('www.domain.com', 80).returns(request)
    request.expects(:post).with('/some/url?key1=value1&key2=value2', @body).returns(response)
    
    res = @job.perform
    
    assert_equal response, res
  end
  
end