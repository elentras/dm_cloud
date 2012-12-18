# DmCloud

[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/elentras/dm_cloud)

I created this gem to simplify request and responses from DailyMotion Cloud API.  
With this gem, you can :  
- get generated embed code as a string  
- get direct access url to your files (I used this to provide video flux to TV-connected application)  
- (Lists works, others on the way) create, delete, paginated lists of videos; with video informations (a/v encodings, bitrate, video lenght...)  
- (I'm working on ) CRUD on videos' meta-data  

## Installation

Add this line to your application's Gemfile:

    gem 'dm_cloud', "0.0.60" #stable version
or  
 	gem 'dm_cloud' # edge version
  
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
    
    DmCloud.configure( { 
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

    DmCloud::Streaming.embed('your video id looks like a secret key')

Or how to get your direct url :  
It will return a string containing the direct link to your file.  

    DmCloud::Streaming.url('your video id', ['asset_name'], {options})

The next parts will come soon, just need some time to finish it  
and create corresponding tests.  

---
### Video explorer :  

If you need to list your video you can use this method :  

    DmCloud::Media.list({:page => 1, :per_page => 10})
It will return videos information and more :  

result to yaml :  
    
    '{"result": {  
      "list": [{  
        "embed_url": "http://api.DmCloud.net/player/embed/:your_id/:media_id",  
        "assets": {  
          "source": {  
            "status": "ready",  
            "video_fps": 25.0,  
            "file_extension": "mp4",  
            "video_fps_mode": "CFR",  
            "container": "MPEG-4",  
            "audio_samplerate": 44100,  
            "video_interlaced": false,
            "video_rotation": 0.0,  
            "video_bitrate": 1000618,  
            "created": 1347641702,  
            "audio_nbr_channel": 2,  
            "download_url": "http://cdn.DmCloud.net/route/http/:your_id/:media_id/source-1347634502.mp4?filename=my_video_name-source-1347634502.mp4&auth=1351277028-3-672hcu1m-3fcab065b9bf103e70d3883aa8c657be",  
            "video_aspect": 1.7777777777777777,  
            "video_height": 576,  
            "audio_bitrate": 128017,  
            "audio_codec": "AAC LC",  
            "file_size": 119133958,  
            "duration": 839,  
            "video_codec": "AVC",  
            "video_width": 1024,  
            "global_bitrate": 1134696}},  
            "created": 1347641696,  
            "meta": { "title": "my video 1 title"},  
            "frame_ratio": 1.7740740740740739,  
            "id": "5053616094739936ec0006af" }],  
      "pages": 1,
      "on_this_page": 3,
      "per_page": 10,
      "total": 3, 
      "page": 1}}'

As you can see, this give many information, you can submit a hash like this :  

    DmCloud::Media.list({:page => 1, :per_page => 10, :fields => {:meta => :title }, :assets => [:download_url, :created ]})



## Contributing

Your welcome to share and enhance this gem.  
This is my first one (and not the last one) but I know some mistakes might be done by myself.  
I do my best and I'm open to all ideas or comments about my work.  

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
