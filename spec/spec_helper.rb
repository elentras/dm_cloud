$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '/../', 'lib'))
require 'rubygems'
require 'rspec'
require 'rspec/autorun'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

#  def self.behavior(obj)
#    if @methods
#      @methods = @methods.select{|met| @methods.member? met }
#    else
#      @methods = obj.public_methods
#    end
#  end
# puts "Common Methods: #{@methods.sort.join(', ')}" if @methods

module Compare
  def self.type(obj)
    @objects ||= []
    @objects << obj
  end

  def self.report
    puts "Object Types: #{@objects.collect{|o| o.class}.join(', ')}" if @objects
  end
end

class Object
  def put_methods(regex=/.*/)
    puts self.methods.grep(regex)
  end
end

RSpec.configure do |config|
  config.after(:suite) do
    Compare.report
  end
end

# Hook on http requests
require 'vcr'

TEST_USER_KEY  = "my_user_key"
TEST_SECRET_KEY = "my_secret_key"

VCR.configure do |c|
  c.cassette_library_dir     = 'spec/cassettes'
  # c.stub_with                :fakeweb
  c.default_cassette_options = { :record => :new_episodes }
end

RSpec.configure do |c|
  c.extend VCR::RSpec::Macros
end