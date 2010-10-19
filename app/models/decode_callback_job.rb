require 'net/http'
require 'uri'

class DecodeCallbackJob
  
  attr_reader :url, :body, :query_parameters
  
  def initialize(url, body, query_parameters)
    @url = url
    @body = body
    @query_parameters = query_parameters
  end
  
  def perform
    url = URI.parse @url
    
    request = Net::HTTP.new url.host, url.port
    response = request.post "#{url.path}?#{@query_parameters.to_query}", @body, {'Content-Type' => 'text/plain'} # what is the proper mime type for raw data?
  end
end
