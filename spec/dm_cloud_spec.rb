require 'spec_helper'
require 'dm_cloud'

describe DmCloud do
  context "configuration" do
    use_vcr_cassette

    it "should provide a config on DmCloud" do
      DmCloud.should respond_to :config
    end
    
    it "should be initialized with default values" do
      DmCloud.configure
      DmCloud.config[:security_level].should == 'none'
      DmCloud.config[:protocol].should == 'http'
      DmCloud.config[:auto_call].should be_true
    end

    context "after configuration setted" do
      it "should be properly set" do
        DmCloud.configure({user_key: TEST_USER_KEY, secret_key: TEST_SECRET_KEY, auto_call: false })
        DmCloud.config[:user_key].should == TEST_USER_KEY
        DmCloud.config[:secret_key].should == TEST_SECRET_KEY
        DmCloud.config[:auto_call].should == false
      end
    end
  end
end