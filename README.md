# DmCloud

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
You can note the securitylevel, for more information about it, take a look at ``

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



Second part, how to get you embed url :

    DMCloud::Streaming.embed('your video id looks like a secret key')

Or how to get your direct url :

    DMCloud::Streaming.url('your video id', ['asset_name'], {options})

The next parts will come soon, just need some time to finish its and create corresponding tests.

## Contributing

Your welcome to share and enhance this gem. 
This is my first one (and not the last one) but I know some mistakes might be done by myself.
I do my best and I'm open to all ideas or comments about my work.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
