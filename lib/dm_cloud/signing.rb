module DMCloud
  class Signing
    # To sign a URL, the client needs a secret shared with Dailymotion Cloud.
    # This secret is call client secret and is available in the back-office interface.
    # Params:
    #   expires: An expiration timestamp.
    #   sec-level: A security level mask.
    #   url-no-query: The URL without the query-string.
    #   nonce: A 8 characters-long random alphanumeric lowercase string to make the signature unique.
    #   secret: The client secret.
    #   sec-data: If sec-level doesn’t have the DELEGATED bit activated,
    #     this component contains concatenated informations 
    #     for all activated sec levels.
    #   pub-sec-data: Some sec level data have to be passed in clear in the signature.
    #     To generate this component the parameters are serialized using x-www-form-urlencoded, compressed with gzip and encoded in base64.
    # Result :
    #   return a string which contain the signed url like 
    #   <url>?auth=<expires>-<sec>-<nonce>-<md5sum>[-<pub-sec-data>]
    def self.sign(stream)
      raise StandardError, "missing :stream in params" unless stream
      security = security(DMCloud.config[:security_level])
      sec_data = security_data(DMCloud.config[:security_level])

      base = { 
        :sec_level => security(DMCloud.config[:security_level]),
        :url_no_query => stream,
        :expires => (Time.now + 1.hour).to_i,
        :nonce => SecureRandom.hex(16)[0,8],
        :secret => DMCloud.config[:secret_key]
      }
      base.merge!(:sec_data => sec_data, :pub_sec_data => sec_data) unless sec_data.nil?
      puts base
      digest_struct = build_digest_struct(base)

      check_sum = Digest::MD5.hexdigest(digest_struct)

      signed_url = [base[:expires], base[:sec_level], base[:nonce], check_sum].compact
      signed_url.merge!(:pub_sec_data => sec_data) unless sec_data.nil?
      
      puts signed_url
      
      signed_url = signed_url.join('-')
      signed_url
    end
    
    # Prepare datas for signing
    # Params :
    #   base : contains media id and others for url signing
    def self.build_digest_struct(base)
      result = []
      base.each_pair { |key, value| result << value }
      result.join('')
    end

    # The client must choose a security level for the signature.
    # Security level defines the mechanism used by Dailymotion Cloud architecture
    # to ensure the signed URL will be used by a single end-user.
    # Params :
    #   type :
    #     None: The signed URL will be valid for everyone
    #     ASNUM: The signed URL will only be valid for the AS of the end-user.
    #       The ASNUM (for Autonomous System Number) stands for the network identification,
    #       each ISP have a different ASNUM for instance.
    #     IP: The signed URL will only be valid for the IP of the end-user.
    #       This security level may wrongly block some users
    #       which have their internet access load-balanced between several proxies.
    #       This is the case in some office network or some ISPs.
    #     User-Agent: Used in addition to one of the two former levels, 
    #       this level a limit on the exact user-agent of the end-user.
    #       This is more secure but in some specific condition may lead to wrongly blocked users.
    #     Use Once: The signed URL will only be usable once.
    #       Note: should not be used with stream URLs.
    #     Country: The URL can only be queried from specified countrie(s).
    #       The rule can be reversed to allow all countries except some.
    #     Referer: The URL can only be queried 
    #       if the Referer HTTP header contains a specified value.
    #       If the URL contains a Referer header with a different value,
    #       the request is refused. If the Referer header is missing,
    #       the request is accepted in order to prevent from false positives as some browsers, 
    #       anti-virus or enterprise proxies may remove this header.
    #     Delegate: This option instructs the signing algorithm 
    #       that security level information won’t be embeded into the signature
    #       but gathered and lock at the first use.
    # Result :
    #   Return a string which contain the signed url like 
    #   http://cdn.dmcloud.net/route/<user_id>/<media_id>/<asset_name>.<asset_extension>?auth=<auth_token>
    def self.security(type = nil)
      type = :none unless type
      type = type.to_sym if type.class == String
      
      result = case type
        when :none
          0 # None
        when :delegate
          1 << 0  # None
        when :asnum
          1 << 1  # The number part of the end-user AS prefixed by the ‘AS’ string (ie: as=AS41690)
        when :ip
          1 << 2  # The end-user quad dotted IP address (ie: ip=195.8.215.138)
        when :user_agent
          1 << 3  # The end-user browser user-agent (parameter name is ua)
        when :use_once
          1 << 4  # None
        when :country
          1 << 5  # A list of 2 characters long country codes in lowercase by comas. If the list starts with a dash, the rule is inverted (ie: cc=fr,gb,de or cc=-fr,it). This data have to be stored in pub-sec-data component
        when :referer
          1 << 6  # A list of URL prefixes separated by spaces stored in the pub-sec-data component (ex: rf=http;//domain.com/a/+http:/domain.com/b/).
      end
      result
    end

    def self.security_data(type, value = nil)
      type = type.to_sym if type.class == String
      
      result = case type
        when :asnum
          "as=#{value}"  # The number part of the end-user AS prefixed by the ‘AS’ string (ie: as=AS41690)
        when :ip
          "ip=#{value}"  # The end-user quad dotted IP address (ie: ip=195.8.215.138)
        when :user_agent
          "ua=#{value}"  # The end-user browser user-agent (parameter name is ua)
        when :country
          "cc=#{value}"  # A list of 2 characters long country codes in lowercase by comas. If the list starts with a dash, the rule is inverted (ie: cc=fr,gb,de or cc=-fr,it). This data have to be stored in pub-sec-data component
        when :referer
          "rf=#{value}"  # A list of URL prefixes separated by spaces stored in the pub-sec-data component (ex: rf=http;//domain.com/a/+http:/domain.com/b/).
        else
          nil
      end
      result
    end

    def self.security_pub_sec_data(type, value)
      type = type.to_sym if type.class == String
      
      result = case type
        when :country
          "cc=#{value}"  # A list of 2 characters long country codes in lowercase by comas. If the list starts with a dash, the rule is inverted (ie: cc=fr,gb,de or cc=-fr,it). This data have to be stored in pub-sec-data component
        when :referer
          "rf=#{value}"  # A list of URL prefixes separated by spaces stored in the pub-sec-data component (ex: rf=http;//domain.com/a/+http:/domain.com/b/).
        else
          nil
      end
      result
    end
  end
end