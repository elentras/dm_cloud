require 'dm_cloud/builder/media'

module DmCloud
  class Media
    # Creates a new media object.
    # This method can either create an empty media object
    # or also download a media with the url paramater
    # and use it as the source to encode the ASSET_NAME listed in assets_names
    # Params :
    #   args: 
    #     url: SCHEME://USER:PASSWORD@HOSTNAME/MY/PATH/FILENAME.EXTENSION (could be ftp or http)
    #     author: an author name
    #     title: a title for the film
    #     assets_names: (Array) – (optional) the list of ASSET_NAME you want to transcode,
    #       when you set this parameter you must also set the url parameter
    # Return :
    #   media_id: return the media id of the object
    def self.create(options)
      call_type = "media.create"

      params = {
        :call =>  call_type,
        args: Builder::Media.create(options)
      }
      DmCloud.config[:auto_call] == true ? DmCloud::Request.execute(call_type, params) : {call: call_type, params: params}
    end
    
    # Delete a media object with all its associated assets.
    # 
    # Parameters: 
    #   id (media ID) – (required) the id of the media object you want to delete.
    # Return :
    #   Nothing
    def self.delete(media_id)
      raise StandardError, "missing :media_id in params" unless media_id
      call_type = "media.delete"

      params = {
        :call =>  call_type,
        args: { id: media_id}
      }
      DmCloud.config[:auto_call] == true ? DmCloud::Request.execute(call_type, params) : {call: call_type, params: params}
    end
    
    # Gives information about a given media object.
    # 
    # Params :
    #   media_id: (media ID) – (required) the id of the new media object.
    #   fields (Array) – (required) the list of fields to retrieve.
    # Returns:
    #   a multi-level structure containing about the media related to the requested fields.
    def self.info(media_id, assets_names = ['source'], fields = {})
      raise StandardError, "missing :media_id in params" unless media_id
      call_type = "media.info"

      params = {
        :call =>  call_type,
        args: DmCloud::Builder::Media.info(media_id, assets_names, fields)
      }
      DmCloud.config[:auto_call] == true ? DmCloud::Request.execute(call_type, params) : {call: call_type, params: params}
    end
    
    # Returns a paginated list of media info structures.
    # You must specify the fields you want to retrieve.
    # The fields are described in the documentation of the method info.
    # 
    # Parameters: 
    #   options:
    #     fields (Array) – (optional default return all informations) the fields to retrieve
    #     page (Integer) – (optional) the page number, default: 1
    #     per_page (Integer) – (optional) the number of objet per page, default: 10
    #     Returns:
    #     an object with information for the pagination and the result of the query.
    def self.list(options = {})
      call_type = "media.list"

      page = options[:page] ? options[:page] : 1
      per_page = options[:per_page] ? options[:per_page] : 10

      params = {
        :call =>  call_type,
        args: DmCloud::Builder::Media.list(options),
        :page => page,
        :per_page => per_page
      }
      DmCloud.config[:auto_call] == true ? DmCloud::Request.execute(call_type, params) : {call: call_type, params: params}
    end
    
  end
end