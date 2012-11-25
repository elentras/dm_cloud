require 'yaml'

# This gem's comments come from DailyMotion Cloud API,
# that's the better way to see changes on new version and logic.
# For parts more generals and not representating DailyMotion Cloud API,
# I add some about my own opinion.
module DmCloud
  
  # Configuration defaults
  # I used this parts from Slainer68 paybox_system gem.
  # I liked the concept and how he handle this part.
  # Thx Slainer68, I created my first gem, 
  # and next one will be an update to your paybox_system gem.
  @@config = {
    security_level: 'none',
    protocol: 'http',
    auto_call: true,
    user_key: nil,
    secret_key: nil
  }

  YAML_INITIALIZER_PATH = File.dirname(__FILE__)
  @valid_config_keys = @@config.keys

  # Configure through hash
  def self.configure(opts = {})
    opts.each {|k,v| @@config[k.to_sym] = v } # if @valid_config_keys.include? k.to_sym}
  end

  # Configure through yaml file
  # for ruby scripting usage
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

  # Access to config variables (security level, user_id and api_key)
  def self.config
    @@config = configure unless @@config
    @@config
  end

  # Loading classes to easier access
  # NOTE: I like this way to handle my classes,
  #   sexiest than using require 'my_class_file' everywhere
  autoload(:Streaming, 'dm_cloud/streaming')
  autoload(:Media, 'dm_cloud/media')
  autoload(:Request, 'dm_cloud/request')
  autoload(:Signing, 'dm_cloud/signing')
end