require 'net/http'
require 'json'

module DmCloud
  class Request
    
    DAILYMOTION_API = 'http://api.DmCloud.net/api'
    DAILYMOTION_STATIC = 'http://api.DmCloud.net/api'
    
    # This method control signing for Media calls and handle request and response.
    def self.execute(call, params = {})
      url = define(call)
      params['auth'] = DmCloud::Signing.identify(params)

      result = send_request(params)
      parse_response(result)
    end
    
    
    def self.send_request(params)
      @uri = URI.parse(DAILYMOTION_API)

      http    = Net::HTTP.new(@uri.host, @uri.port)
      request = Net::HTTP::Post.new(@uri.request_uri)
      request.content_type = 'application/json'
      request.body = params.to_json
      
      # puts 'request (YAML format ): ' + request.to_yaml + "\n" + '-' * 80
      
      http.request(request).body
    end
    

    
    def self.parse_response(result)
      JSON.parse(result)
    end
    
    def self.define(action)
      DAILYMOTION_API 
    end
  end
end