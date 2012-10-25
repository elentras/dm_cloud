# DMCloud

I created this gem to simplify request and responses from DailyMotion Cloud API.
With this gem, you can :
- get generated embed code as a string
- get direct access url to your files (I used this to provide video flux to TV-connected application)
- (I'm working on ) video creation, delete, paginated lists and video informations (a/v encodings, bitrate, video lenght...)
- (I'm working on ) CRUD on videos' meta-data

## Installation

Add this line to your application's Gemfile:

    gem 'dm_cloud'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dm_cloud

## Usage

First, your will need to specify your :user_id, :api_key and your security level.  
I used a file in `APP_ROOT/config/initializers/conf.rb`.  
You can note the securitylevel, for more information about it, take a look at `lib/dm_cloud/signing.rb`.  

    # DAILYMOTION CLOUD SETTINGS
    require 'dm_cloud'
    DMC_USER_ID = 'your user id'
    DMC_SECRET = 'your api key'
    DMC_SECURITY_LEVEL = :none
    
    DMCloud.configure( { 
      :user_key    =>     DMC_USER_ID,
      :secret_key =>      DMC_SECRET,
      :security_level =>  DMC_SECURITY_LEVEL
    })

Description of security levels :

  *  **None:**  
      The signed URL will be valid for everyone  
  *  **ASNUM:**  
      The signed URL will only be valid for the AS of the end-user.  
      The ASNUM (for Autonomous System Number) stands for the network identification,  
      each ISP have a different ASNUM for instance.  
  *  **IP:**  
      The signed URL will only be valid for the IP of the end-user.  
      This security level may wrongly block some users  
      which have their internet access load-balanced between several proxies.  
      This is the case in some office network or some ISPs.  
  * **User-Agent:** 
      Used in addition to one of the two former levels,   
      this level a limit on the exact user-agent of the end-user.  
      This is more secure but in some specific condition may lead to wrongly blocked users.  
  * **Use Once:**  
      The signed URL will only be usable once.  
      Note: should not be used with stream URLs.  
  * **Country:**  
      The URL can only be queried from specified countrie(s).  
      The rule can be reversed to allow all countries except some.  
  * **Referer:**  
      The URL can only be queried   
      if the Referer HTTP header contains a specified value.  
      If the URL contains a Referer header with a different value,  
      the request is refused. If the Referer header is missing,  
      the request is accepted in order to prevent from false positives as some browsers,  
      anti-virus or enterprise proxies may remove this header.  
  * **Delegate:**  
      This option instructs the signing algorithm   
      that security level information won’t be embeded into the signature  
      but gathered and lock at the first use.  
  

Second part, get you embed url :  
It will return a string containing the iframe with the DailyMotion Cloud player.  

    DMCloud::Streaming.embed('your video id looks like a secret key')

Or how to get your direct url :  
It will return a string containing the direct link to your file.  

    DMCloud::Streaming.url('your video id', ['asset_name'], {options})

The next parts will come soon, just need some time to finish it  
and create corresponding tests.  

## Contributing

Your welcome to share and enhance this gem.  
This is my first one (and not the last one) but I know some mistakes might be done by myself.  
I do my best and I'm open to all ideas or comments about my work.  

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
