module DMCloud
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
    def self.create(media_id)
      call = "media.create"

      params = {
        call: call,
        args: DMCloud::Builder::Media.create(args)
      }
      DMCloud::Request.execute(call, params)
    end
    
    # Delete a media object with all its associated assets.
    # 
    # Parameters: 
    #   id (media ID) – (required) the id of the media object you want to delete.
    # Return :
    #   Nothing
    def self.delete
      call = "media.delete"

      params = {
        call: call,
        args: { id: media_id}
      }
      DMCloud::Request.execute(call, params)
    end
    
    def self.info(fields = [])
      call = "media.info"

      params = {
        call: call,
        args: DMCloud::Builder::Media.info(fields)
      }
      DMCloud::Request.execute(call, params)
    end
    
    # Gives information about a given media object.
    # 
    # Params :
    #   media_id: (media ID) – (required) the id of the new media object.
    #   fields (Array) – (required) the list of fields to retrieve.
    # Returns:	a multi-level structure containing about the media related to the requested fields.
    Return type:	Object
    def self.list(options = {})
      call = "media.list"
      page = options[:page].present? ? options[:page] : 1
      per_page = options[:per_page].present? ? options[:per_page] : 10

      params = {
        call: call,
        args: DMCloud::Builder::Media.list(options)
      }
      DMCloud::Request.execute(call, params)
    end
    
  end
end