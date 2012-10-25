module DMCloud
  class Request
    
    
    def self.execute(call, params = {})
      request = DMCloud.identify(params)
      params.merge!({'auth' => request})
      result = DMCloud::Request.new(params)
      DMCloud::Response.parse(call, result)
    end
    
  end
end