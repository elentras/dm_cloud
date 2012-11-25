require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'dm_cloud/signing'

describe DmCloud::Signing do

  before do
    DmCloud.configure({ :user_key => "hello world", :secret_key => "sEcReT_KeY" })
  end

  it "should sign 'hello world' with sEcReT_KeY and returns 'b5d93121a6dc87562b46beb8ba809ace'" do
    auth_token = subject { identify() }
    auth_token.should == 'b5d93121a6dc87562b46beb8ba809ace'
  end

  it "it should sign an url" do
    let(:signed_url) { stub(:sign).with("http://google.fr","olol") }
  end
  
  context "Normalizing" do
      {
        'foo42bar'                  => ['foo', 42, 'bar'],
        'pink3red2yellow1'          => {'yellow' => 1, 'red' => 2, 'pink' => 3},
        'foo42pink3red2yellow1bar'  => ['foo', 42, {'yellow' => 1, 'red' => 2, 'pink' => 3}, 'bar'],
        'foo42pink3red2yellow1bar'  => [:foo, 42, {:yellow => 1, :red => 2, :pink => 3}, :bar],
        '12'                        => [nil, 1,2],
        ''                          => nil,
        '212345'                    => {2 => [nil, 1,2], 3 => nil, 4 => 5}
      }.each do |normalized, original| 
        it "should normalize #{original.inspect} into #{normalized}" do
          subject { normalize(original).should == normalized }
        end
      end
    end
  
end