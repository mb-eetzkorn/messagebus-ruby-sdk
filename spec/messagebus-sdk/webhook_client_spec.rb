
dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/../../lib/messagebus-sdk/webhook_client"

describe MessagebusWebhookClient do
  attr_reader :client, :api_key

  before do
    FakeWeb.allow_net_connect = false
    @api_key = "7215ee9c7d9dc229d2921a40e899ec5f"
    @client = MessagebusWebhookClient.new(@api_key)
  end

  describe "webhooks" do
    it "#webhooks" do
      expected_request="#{API_URL}/webhooks"
      FakeWeb.register_uri(:get, expected_request, :body => json_webhooks)

      response = client.webhooks
      response.should == json_parse(json_webhooks)

      response[:webhooks].length.should == 2
    end

    it "#webhook" do
      webhook_key = "ab487e9d750a3c50876d12e8f381a79f"

      expected_request="#{API_URL}/webhook/#{webhook_key}"
      FakeWeb.register_uri(:get, expected_request, :body => json_webhook)

      response = client.webhook(webhook_key)
      response.should == json_parse(json_webhook)
    end

    it "#create" do
      params = {:enabled => false,
                :uri => 'http://domain.com/events/messagebus/message.accept',
                :eventType => MessagebusWebhookClient::EVENT_TYPE_MESSAGE_ACCEPT
               }

      expected_request="#{API_URL}/webhooks"
      FakeWeb.register_uri(:post, expected_request, :body => json_webhook_create)

      response = client.create(params)
      response.should == json_parse(json_webhook_create)
    end

    it "#update" do
      webhook_key = "ab487e9d750a3c50876d12e8f381a79f"
      params = {:uri => 'http://domain.com/events/messagebus/message.accepted'}

      expected_request="#{API_URL}/webhook/#{webhook_key}"
      FakeWeb.register_uri(:put, expected_request, :body => json_webhook_update)

      response = client.update(webhook_key, params)
      response.should == json_parse(json_webhook_update)
    end

    it "#delete_webhook" do
      webhook_key = "ab487e9d750a3c50876d12e8f381a79f"

      expected_request="#{API_URL}/webhook/#{webhook_key}"
      FakeWeb.register_uri(:delete, expected_request, :body => json_webhook_delete)

      response = client.delete(webhook_key)
      response.should == json_parse(json_webhook_delete)

    end

  end
end