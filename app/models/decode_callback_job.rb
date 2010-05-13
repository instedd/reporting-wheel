require 'net/http'
require 'uri'
require 'cgi'

class DecodeCallbackJob
  
  attr_reader :url, :body, :query_parameters
  
  def initialize(url, body, query_parameters)
    @url = url
    @body = body
    @query_parameters = query_parameters
  end
  
  def perform
    url = URI.parse(@url)
    query_string = @query_parameters.map{|k,v| CGI::escape(k.to_s) + '=' + CGI::escape(v.to_s)}.join('&')
    
    request = Net::HTTP.new(url.host, url.port)
    response = request.post(url.path + '?' + query_string, @body)
  end
end