
dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/../../lib/messagebus-sdk/feedback_client"


describe MessagebusFeedbackClient do
  attr_reader :client, :api_key


  before do
    FakeWeb.allow_net_connect = false
    @api_key = "7215ee9c7d9dc229d2921a40e899ec5f"
    @client = MessagebusFeedbackClient.new(@api_key)
  end

  describe "feedback" do
    it "call #feedback without dates" do
      scope = "all"
      expected_request="#{API_URL}/feedback?useSendTime=true&scope=#{scope}"

      FakeWeb.register_uri(:get, expected_request, :body => json_feedback(scope))
      response = client.feedback
      FakeWeb.last_request.body.should be_nil
      response.should == json_parse(json_feedback(scope))
    end

    it "call #feedback with dates" do
      scope = "bounces"
      start_date_str="2011-01-01T04:30:00+00:00"
      end_date_str="2011-01-02T04:30:00+00:00"
      expected_request="#{API_URL}/feedback?useSendTime=true&scope=#{scope}&startDate=#{URI.escape(start_date_str)}&endDate=#{URI.escape(end_date_str)}"

      FakeWeb.register_uri(:get, expected_request, :body => json_feedback(scope))
      response = client.feedback(start_date_str, end_date_str, scope)
      FakeWeb.last_request.body.should be_nil
      response.should == json_parse(json_feedback(scope))
    end

    it "call #feedback_by_channel without dates" do
      scope = "all"
      channel_key = "ab487e9d750a3c50876d12e8f381a79f"
      expected_request="#{API_URL}/feedback/channel/#{channel_key}?useSendTime=true&scope=#{scope}"

      FakeWeb.register_uri(:get, expected_request, :body => json_feedback(scope))
      response = client.feedback_by_channel(channel_key)
      FakeWeb.last_request.body.should be_nil
      response.should == json_parse(json_feedback(scope))
    end

    it "call #feedback_by_session without dates" do
      scope = "all"
      channel_key = "ab487e9d750a3c50876d12e8f381a79f"
      session_key = "dab775c6e6aa203324598fefbd1e8baf"

      expected_request="#{API_URL}/feedback/channel/#{channel_key}/session/#{session_key}?useSendTime=true&scope=#{scope}"

      FakeWeb.register_uri(:get, expected_request, :body => json_feedback(scope))
      response = client.feedback_by_session(channel_key, session_key)
      FakeWeb.last_request.body.should be_nil
      response.should == json_parse(json_feedback(scope))
    end
  end

end