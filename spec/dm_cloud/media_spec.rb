require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require 'dm_cloud/media'

describe DmCloud::Media do
  use_vcr_cassette

  context "Using test account" do
    before :each do
      DmCloud.configure({:user_key => TEST_USER_KEY, :secret_key => TEST_SECRET_KEY, auto_call: false})
    end

    context "Having a collection" do
      it "should list four medias" do
        subject { list(:per_page => 20)['result']['total'].should == (4) }
      end

      it "should get all the titles" do
        result = DmCloud::Media.list(:fields => {:meta => [:title]}, :per_page => 20) #['result']['list']
        result[:call].should == "media.list"
        result[:params][:args][:fields].should include("meta.title")
      end

      it "should get page 2 with 2 records per page" do
        result = DmCloud::Media.list(:per_page => 2, :page => 2)
        result[:params][:page].should == 2
        result[:params][:per_page].should == 2
      end
    end

    context "Querying a single media" do
      it "should have an default fields" do
        result = DmCloud::Media.info('4f33ddbc94a6f6517c001577')
        fields = result[:params][:args][:fields]
        puts fields.to_yaml
        fields.should include('embed_url')
      end

      # it "should have a stream url" do
      #         subject { stream_url('4f33ddbc94a6f6517c001577').should include("http://cdn.DmCloud.net/route/4f33d9c8f325e11c830016af/4f33ddbc94a6f6517c001577/mp4_h264_aac.mp4")
      #       end
      # 
      #       it "should have http detected as protocol" do
      #         @cloudkey.media.stream_url('4f33ddbc94a6f6517c001577', 'mp4_h264_aac',Cloudkey::SecurityPolicy.new, :download => true).should include("/http/")
      #       end
    end
  end
end