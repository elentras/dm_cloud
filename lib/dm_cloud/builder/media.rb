module DMCloud
  module Builder
    module Media
      def self.create(url = '', assets_names = [], meta = {})
        request = Hash.new

        request['url'] = url

        if not meta.empty?
          request['meta'] = {}
          request['meta']['author'] = meta[:author] if meta[:author]
          request['meta']['author'] = meta[:title] if meta[:title]
        end

        request['assets_names'] = assets_names if not assets_names.empty?

        request.rehash
      end
      
      def self.info(media_id, assets_names = ['source'], fields = {})
        raise StandardError, "missing :media_id in params" unless media_id
        request = Hash.new

        # the media id
        request['id'] = media_id
        request['fields'] = []

        # requested media meta datas
        fields[:meta] = [ 'title']  unless fields[:meta]
        fields[:meta].each { |value| request['fields'] << "meta.#{value.to_s}" }
        request['fields'] += ['id', 'created', 'embed_url', 'frame_ratio']

        # the worldwide statistics on the number of views
        # request['fields'] << 'stats.global.last_week' if fields[:stats][:global]

        # TODO: handle statistics request per country
        # fields[:stats].each { |key| request << "meta.#{key.to_s}" } if fields[:meta].present?
        # request['stats'][COUNTRY_CODE][TIME_INTERVAL] : the statistics on the number of views in a specific country (eg: stats.fr.total, stats.us.last_week, etc...)
        # request['extended_stats'][COUNTRY_CODE][TIME_INTERVAL]

        assets_names = ['source'] if assets_names.nil?
        if not fields[:assets]
          request = all_assets_fields(request, assets_names)
        else
          assets_names.each do |name|
            fields[:assets].each { |value| request << "assets.#{name}.#{value.to_s}" }
          end
        end
        
        request
      end
      
      def self.list(fields = {})
        # raise StandardError, "missing :media_id in params" unless media_id
        request = Hash.new

        request['fields'] = []
        # requested media meta datas
        fields[:meta] = [ 'title']  unless fields[:meta].present?
        fields[:meta].each { |value| request['fields'] << "meta.#{value.to_s}" }
        request['fields'] += ['id', 'created', 'embed_url', 'frame_ratio']

        # TODO: handle global statistics request in another module
        # the worldwide statistics on the number of views
        # request << 'stats.global.last_week' if fields[:stats][:global]

        # TODO: handle statistics request per country
        # fields[:stats].each { |key| request << "meta.#{key.to_s}" } if fields[:meta].present?
        # request['stats'][COUNTRY_CODE][TIME_INTERVAL] : the statistics on the number of views in a specific country (eg: stats.fr.total, stats.us.last_week, etc...)
        # request['extended_stats'][COUNTRY_CODE][TIME_INTERVAL]
        
         assets_names = ['source'] if assets_names.nil?
          if not fields[:assets]
            request = all_assets_fields(request, assets_names)
          else
            assets_names.each do |name|
              fields[:assets].each { |value| request['fields'] << "assets.#{name}.#{value.to_s}" }
            end
          end

          request
      end


      protected
        # This method exclude stats, but return all information for a media (video or images)
        # NOTE: This is outside the methods because : too long and recurent.
        #   It's also used as default if no fields params is submitted.
        def self.all_assets_fields(request, assets_names)
          assets_names.each do |name|
            request['fields'] << "assets.#{name}.download_url"
            request['fields'] << "assets.#{name}.status"
            request['fields'] << "assets.#{name}.container"
            request['fields'] << "assets.#{name}.duration"
            request['fields'] << "assets.#{name}.global_bitrate"
            request['fields'] << "assets.#{name}.video_codec"
            request['fields'] << "assets.#{name}.video_width"
            request['fields'] << "assets.#{name}.video_height"
            request['fields'] << "assets.#{name}.video_bitrate"
            request['fields'] << "assets.#{name}.video_rotation"
            request['fields'] << "assets.#{name}.video_fps"
            request['fields'] << "assets.#{name}.video_fps_mode"
            request['fields'] << "assets.#{name}.video_aspect"
            request['fields'] << "assets.#{name}.video_interlaced"
            request['fields'] << "assets.#{name}.audio_codec"
            request['fields'] << "assets.#{name}.audio_bitrate"
            request['fields'] << "assets.#{name}.audio_nbr_channel"
            request['fields'] << "assets.#{name}.audio_samplerate"
            request['fields'] << "assets.#{name}.created"
            request['fields'] << "assets.#{name}.file_extension"
            request['fields'] << "assets.#{name}.file_size"
          end
          request
        end

    end
  end
end