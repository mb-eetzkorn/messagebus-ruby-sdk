
dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/../../lib/messagebus-sdk/api_client"

describe MessagebusApiClient do

  class MessagebusApiTest < MessagebusApiClient
    attr_accessor :last_init_time
  end

  def default_message_params
    {:toEmail => 'apitest1@messagebus.com',
     :toName => 'EmailUser',
     :fromEmail => 'api@messagebus.com',
     :fromName => 'API',
     :subject => 'Unit Test Message',
     :customHeaders => ["sender"=>"apitest1@messagebus.com"],
     :plaintextBody => 'This message is only a test sent by the Ruby Message Bus client library.',
     :htmlBody => "<html><body>This message is only a test sent by the Ruby Message Bus client library.</body></html>",
     :sessionKey => "dab775c6e6aa203324598fefbd1e8baf"
    }
  end

  attr_reader :client, :api_key

  before do
    FakeWeb.allow_net_connect = false
    @api_key = "7215ee9c7d9dc229d2921a40e899ec5f"
    @client = MessagebusApiClient.new(@api_key)
  end

  describe "#send_messages" do
    it "should have user-agent and x-messagebus-key set in request headers" do
      FakeWeb.register_uri(:post, "#{API_URL}/messages/send", :body => json_valid_send)
      client.send_messages(default_message_params)

      FakeWeb.last_request.get_fields("X-MessageBus-Key").should_not be_nil
      FakeWeb.last_request.get_fields("User-Agent").should_not be_nil
      FakeWeb.last_request.get_fields("Content-Type").should_not be_nil
    end

    it "sends messages" do
      FakeWeb.register_uri(:post, "#{API_URL}/messages/send", :body => json_valid_send)
      results = client.send_messages(default_message_params)
      results[:results].size.should == 1
    end
  end

  describe "http connection" do
    before do
      @http_client = MessagebusApiTest.new(@api_key)
    end

    it "doesnt reset connection if under a minute old" do
      current_init_time=@http_client.last_init_time
      current_init_time.should be > Time.now.utc-5
      FakeWeb.register_uri(:post, "#{API_URL}/messages/send", :body => json_valid_send)
      results = @http_client.send_messages(default_message_params)
      results[:results].size.should == 1
      @http_client.last_init_time.should == current_init_time
    end

    it "resets connection if over a minute old" do
      @http_client.last_init_time=Time.now.utc-60
      current_init_time=@http_client.last_init_time
      current_init_time.should be < Time.now.utc-59
      FakeWeb.register_uri(:post, "#{API_URL}/messages/send", :body => json_valid_send)
      results = @http_client.send_messages(default_message_params)
      results[:results].size.should == 1
      @http_client.last_init_time.should be > current_init_time
    end
  end

end