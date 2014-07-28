
dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/../../lib/messagebus-sdk/api_client"

describe MessagebusActionMailerClient do
  attr_reader :client, :api_key

  before do
    FakeWeb.allow_net_connect = false
    @api_key = "7215ee9c7d9dc229d2921a40e899ec5f"
    @client = MessagebusApiClient.new(@api_key)
  end

  describe "#deliver" do
    it "works with action mailer" do
      to_email = "hello@example.com"
      session_key = "DEFAULT"
      message = MessageBusActionMailerTest.new_message(to_email, session_key)

      FakeWeb.register_uri(:post, "#{API_URL}/messages/send", :body => json_valid_send)
      message.deliver

      message_body = JSON.parse(FakeWeb.last_request.body)
      message_params = message_body["messages"][0]
      message_params["toName"].should == ""
      message_params["toEmail"].should == to_email
      message_params["sessionKey"].should == "DEFAULT"
      message_params["returnPath"].should == "bounce@bounce.example.com"
    end

    it "works with from with nice name in address" do
      to_email = "Joe Mail <hello_joe@example.com>"
      session_key = "5b39c8b553c821e7cddc6da64b5bd2ee"
      message = MessageBusActionMailerTest.new_message(to_email, session_key)

      FakeWeb.register_uri(:post, "#{API_URL}/message/email/send", :body => json_valid_send)
      message.deliver

      message_body = JSON.parse(FakeWeb.last_request.body)
      message_params = message_body["messages"][0]
      message_params["toName"].should == ""
      message_params["toEmail"].should == "hello_joe@example.com"
      message_params["fromName"].should == "Mail Test"
      message_params["fromEmail"].should == "no-reply@messagebus.com"
      message_params["sessionKey"].should == session_key
    end

    it "adds bcc and x-* headers to custom_headers" do
      to_email = "hello@example.com"
      session_key = "DEFAULT"
      bcc = "goodbye@example.com"
      x_headers = {"x-header-a" => "header1", "x-tracking" => "1234"}
      message = MessageBusActionMailerTest.new_message(to_email, session_key, bcc, x_headers)

      FakeWeb.register_uri(:post, "#{API_URL}/message/email/send", :body => json_valid_send)
      message.deliver

      message_body = JSON.parse(FakeWeb.last_request.body)
      message_params = message_body["messages"][0]
      message_params["toName"].should == ""
      message_params["toEmail"].should == to_email
      message_params["sessionKey"].should == "DEFAULT"
      message_params["returnPath"].should == "bounce@bounce.example.com"
      message_params["customHeaders"]["bcc"].should == "goodbye@example.com"
      message_params["customHeaders"]["x-header-a"].should == "header1"
      message_params["customHeaders"]["x-tracking"].should == "1234"
      message_params["customHeaders"]["X-MESSAGEBUS-SESSIONKEY"].should be_nil
    end

    it "ignores bcc is empty array" do
      to_email = "hello@example.com"
      session_key = "7215ee9c7d9dc229d2921a40e899ec4a"
      bcc = []
      message = MessageBusActionMailerTest.new_message(to_email, session_key, bcc)

      FakeWeb.register_uri(:post, "#{API_URL}/message/email/send", :body => json_valid_send)
      message.deliver

      message_body = JSON.parse(FakeWeb.last_request.body)
      message_params = message_body["messages"][0]
      message_params["sessionKey"].should == session_key
      message_params["customHeaders"]["bcc"].should be_nil
    end
  end
end