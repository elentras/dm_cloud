require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'dm_cloud/streaming'


describe DmCloud::Streaming do
  use_vcr_cassette

  context "check " do
    before :each do
      DmCloud.configure({user_key: TEST_USER_KEY, secret_key: TEST_SECRET_KEY, auto_execute: false})
    end

    context "Querying a single media" do
      it "should have an embedded url" do
        DmCloud::Streaming.embed('4f33ddbc94a6f6517c001577').should include("http://api.DmCloud.net/embed/4f33d9c8f325e11c830016af/4f33ddbc94a6f6517c001577")
      end

      it "should have a stream url" do
        DmCloud::Streaming.url('4f33ddbc94a6f6517c001577', 'source').should include("http://cdn.DmCloud.net/route/4f33d9c8f325e11c830016af/4f33ddbc94a6f6517c001577/mp4_h264_aac.mp4")
      end
    end
  end
end