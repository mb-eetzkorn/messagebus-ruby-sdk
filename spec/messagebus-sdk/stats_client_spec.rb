
dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/../../lib/messagebus-sdk/stats_client"

describe MessagebusStatsClient do
  attr_reader :client, :api_key

  before do
    FakeWeb.allow_net_connect = false
    @api_key = "7215ee9c7d9dc229d2921a40e899ec5f"
    @client = MessagebusStatsClient.new(@api_key)
  end

  describe "stats" do
    it "#stats with dates" do
      start_date_str="2011-01-01"
      end_date_str="2011-01-02"

      expected_request="#{API_URL}/stats/email?startDate=#{start_date_str}&endDate=#{end_date_str}"
      FakeWeb.register_uri(:get, expected_request, :body => json_stats)

      response = client.stats(start_date_str, end_date_str)
      response.should == json_parse(json_stats)

      response[:stats].length.should == 4
      response[:smtp].length.should == 5
      response[:filter].length.should == 2
    end

    it "#stats_by_channel with dates" do
      start_date_str="2011-01-01"
      end_date_str="2011-01-02"
      channel_key = "ab487e9d750a3c50876d12e8f381a79f"

      expected_request="#{API_URL}/stats/email/channel/#{channel_key}?startDate=#{start_date_str}&endDate=#{end_date_str}"
      FakeWeb.register_uri(:get, expected_request, :body => json_stats)

      response = client.stats_by_channel(channel_key, start_date_str, end_date_str)
      response.should == json_parse(json_stats)
    end

    it "#stats_by_session with dates" do
      start_date_str="2011-01-01"
      end_date_str="2011-01-02"
      channel_key = "ab487e9d750a3c50876d12e8f381a79f"
      session_key = "dab775c6e6aa203324598fefbd1e8baf"

      expected_request="#{API_URL}/stats/email/channel/#{channel_key}/session/#{session_key}?startDate=#{start_date_str}&endDate=#{end_date_str}"
      FakeWeb.register_uri(:get, expected_request, :body => json_stats)

      response = client.stats_by_session(channel_key, session_key, start_date_str, end_date_str)
      response.should == json_parse(json_stats)
    end
  end
end