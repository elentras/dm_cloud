require "time"
require "openssl"
require "base64"
require 'digest/md5'

# This module generate methods to generate video's fluxes
# before signing it and request it.
module DmCloud
  class Streaming
      # Default URL to get embed content ou direct url
      DIRECT_STREAM = "[PROTOCOL]://cdn.dmcloud.net/route/[USER_ID]/[MEDIA_ID]/[ASSET_NAME].[ASSET_EXTENSION]"
      EMBED_STREAM = "[PROTOCOL]://api.dmcloud.net/embed/[USER_ID]/[MEDIA_ID]"
      EMBED_IFRAME = '<iframe width="[WIDTH]" height="[HEIGHT]" frameborder="0" scrolling="no" src="[EMBED_URL]"></iframe>'
      
      # Get embeded player
      # Params :
      #   media_id: this is the id of the media (eg: 4c922386dede830447000009)
      #   options:
      #     skin_id: (optional) the id of the custom skin for the video player
      #     width: (optional) the width for the video player frame
      #     height: (optional) the height for the video player frame
      # Result :
      #   return a string which contain the signed url like 
      #   <iframe width="848" height="480" frameborder="0" scrolling="no" src="http://api.DmCloud.net/embed/<user_id>/<media_id>?auth=<auth_token>&skin=<skin_id>"></iframe>
      def self.embed(media_id, options = {})
        raise StandardError, "missing :media_id in params" unless media_id
        
        skin_id = options[:skin_id] ? options[:skin_id]  : 'modern1'
        width   = options[:width]   ? options[:width].to_s    : '848'
        height  = options[:height]  ? options[:height].to_s   : '480'
        
        stream = EMBED_STREAM
        stream.gsub!('[PROTOCOL]', DmCloud.config[:protocol])
        stream.gsub!('[USER_ID]', DmCloud.config[:user_key])
        stream.gsub!('[MEDIA_ID]', media_id)
        signed_url = DmCloud::Signing.sign(stream)
        signed_url = stream + "?auth=#{signed_url}"

        frame = EMBED_IFRAME
        frame.gsub!('[WIDTH]', width)
        frame.gsub!('[HEIGHT]', height)
        frame.gsub!('[EMBED_URL]', signed_url)

        frame.html_safe
      end
      
      # Get media url for direct link to the file on DailyMotion Cloud
      # Params :
      #   media_id: this is the id of the media (eg: 4c922386dede830447000009)
      #   asset_name: the name of the asset you want to stream (eg: mp4_h264_aac)
      #   asset_extension: the extension of the asset, most of the time it is the first part of the asset name (eg: mp4)
      # Result :
      #   return a string which contain the signed url like
      #   http://cdn.DmCloud.net/route/<user_id>/<media_id>/<asset_name>.<asset_extension>?auth=<auth_token>
      def self.url(media_id, asset_name, asset_extension = nil)
        raise StandardError, "missing :media_id in params" unless media_id
        raise StandardError, "missing :asset_name in params" unless asset_name
        asset_extension = asset_name.split('_').first unless asset_extension

        stream = DIRECT_STREAM
        stream.gsub!('[PROTOCOL]', DmCloud.config[:protocol])
        stream.gsub!('[USER_ID]', DmCloud.config[:user_key])
        stream.gsub!('[MEDIA_ID]', media_id)
        stream.gsub!('[ASSET_NAME]', asset_name)
        stream.gsub!('[ASSET_EXTENSION]', asset_extension)
        
        stream += '?auth=[AUTH_TOKEN]'.gsub!('[AUTH_TOKEN]', DmCloud::Signing.sign(stream))
        stream
      end
  end
end