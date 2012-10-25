require "dm_cloud/version"
require 'yaml'
  
module DMCloud
  
  # Configuration defaults
  @@config = {
    :security_level =>  'none',
    :protocol => 'http'
  }

  YAML_INITIALIZER_PATH = File.dirname(__FILE__)
  @valid_config_keys = @@config.keys

  # Configure through hash
  def self.configure(opts = {})
    opts.each {|k,v| @@config[k.to_sym] = v } # if @valid_config_keys.include? k.to_sym}
  end

  # Configure through yaml file
  def self.configure_with(yaml_file_path = nil)
    yaml_file_path = YAML_INITIALIZER_PATH  unless yaml_file_path
    begin
      config = YAML::load(IO.read(path_to_yaml_file))
    rescue Errno::ENOENT
      log(:warning, "YAML configuration file couldn't be found. Using defaults."); return
    rescue Psych::SyntaxError
      log(:warning, "YAML configuration file contains invalid syntax. Using defaults."); return
    end

    configure(config)
  end

  def self.config
    @@config = configure unless @@config
    @@config
  end
  
  def self.create_has_library(library)
      define_singleton_method("has_#{library}?") do
        cv="@@#{library}"
        if !class_variable_defined? cv
          begin 
            require library.to_s
            class_variable_set(cv,true)
          rescue LoadError
            class_variable_set(cv,false)
          end
        end
        class_variable_get(cv)
      end
    end
  
    create_has_library :streaming
    create_has_library :media
  
    class << self
      # Load a object saved on a file.
      def load(filename)
        if File.exists? filename
          o=false
          File.open(filename,"r") {|fp| o=Marshal.load(fp) }
          o
        else
          false
        end
      end
    end
  
  autoload(:Streaming, 'dm_cloud/streaming')
  autoload(:Media, 'dm_cloud/media')
  autoload(:Request, 'dm_cloud/request')
  autoload(:Signing, 'dm_cloud/signing')
end

# Dir.glob('dm_cloud/**/*.rb').each{ |m| require File.dirname(__FILE__) + '/dm_cloud/' + m }
