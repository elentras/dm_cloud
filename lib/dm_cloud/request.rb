require 'net/http'

module DMCloud
  class Request
    
    DAILYMOTION_API = 'http://api.dmcloud.net/api'
    DAILYMOTION_STATIC = 'http://api.dmcloud.net/api'
    
    # This method control signing for Media calls and handle request and response.
    def self.execute(call, params = {})
      url = define(call)
      params['auth'] = DMCloud::Signing.identify(params)

      result = send_request(params)
      parse_response(result)
    end
    
    
    def self.send_request(params)
      @uri = URI.parse(DAILYMOTION_API)

      http    = Net::HTTP.new(@uri.host, @uri.port)
      request = Net::HTTP::Post.new(@uri.request_uri)
      # request.basic_auth @uri.user, @uri.password
      request.content_type = 'application/json'
      request.body = params.to_json
      
      puts 'request (YAML format ): ' + request.to_yaml + "\n" + '-' * 80
      
      http.request(request).body
    end
    

    
    def self.parse_response(result)
      puts 'result : ' + result.to_yaml # For debugging, will be remove when test will exists
      JSON.parse(result)
    end
    
    def self.define(action)
      DAILYMOTION_API 
    end
  end
end