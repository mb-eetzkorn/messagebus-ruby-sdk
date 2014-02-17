
dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/../../lib/messagebus-sdk/template_client"
require "#{dir}/../../lib/messagebus-sdk/messagebus_errors"

describe MessagebusTemplateClient do

  before do
    FakeWeb.allow_net_connect = false
    @api_key = "7215ee9c7d9dc229d2921a40e899ec5f"
    @api_endpoint = "https://templates.messagebus.com"
    @client = MessagebusTemplateClient.new(@api_key)

    @test_template = {
      :toName => "{{rcpt_name}}",
      :toEmail => "{{rcpt_email}}",
      :fromName => "{{sender_name}}",
      :fromEmail => "{{sender_email}}",
      :returnPath => "{{return_path}}",
      :subject => "BOB {{{rcpt_name}}}",
      :plaintextBody => "Plain Text Body {{text_value}}",
      :htmlBody => "<p>The test is working</p>",
      :sessionKey => "{{session_key}}",
      :customHeaders => {"X-MessageBus-Test" => "rBob"}
    }

  end

  describe "templates" do
    it "#template_version" do
        FakeWeb.register_uri(:get, "#{@api_endpoint}/v5/templates/version", :body => json_template_version_results)
        result = @client.template_version

        result[:statusCode].should == 200
        result[:statusMessage].length.should == 40
        result[:version].length.should > 0
    end

    it "#create_template" do
      FakeWeb.register_uri(:post, "#{@api_endpoint}/v5/templates", :body => json_template_create)


      result = @client.create_template(@test_template)

      result[:statusCode].should == 201
      result[:statusMessage].should == "Template saved"
      result[:templateKey].should =~ /^[0-9a-z]{8}-[0-9a-z]{4}-[0-9a-z]{4}-[0-9a-z]{4}-[0-9a-z]{12}$/

    end

    it "#get_template" do
      template_key = "33ffafac-b15e-4146-b046-14ed897c522b"

      FakeWeb.register_uri(:get, "#{@api_endpoint}/v5/template/#{template_key}", :body => json_template_get)

      result = @client.get_template(template_key)

      result[:statusCode].should == 200
      result[:template][:apiKey].should == @api_key

      @test_template.each do |key, value|
        result[:template].has_key?(key).should be_true
      end
    end

    it "#templates" do
      # list templates available
      FakeWeb.register_uri(:get, "#{@api_endpoint}/v5/templates", :body => json_templates_get)

      result = @client.templates

      result[:statusCode].should == 200
      result[:statusMessage].length.should == 0
      result[:count].should == 3

      result[:templates].each do |template|
        template[:templateKey].should =~ /^[0-9a-z]{8}-[0-9a-z]{4}-[0-9a-z]{4}-[0-9a-z]{4}-[0-9a-z]{12}$/
        template[:size].should > 0
      end
    end

    describe "send messages for templates" do
      before do
        @template_params =
          {"rcpt_name" => "Bob",
           "rcpt_email" => "bob@example.com",
           "sender_name" => "Messagebus Ruby SDK",
           "return_path" => "bounce@bounces.messagebus.com",
           "text_value" => "Hello",
           "session_key" => "DEFAULT"
           }
      end

      it "#send_messages with batch size 25" do
        FakeWeb.register_uri(:post, "#{@api_endpoint}/v5/templates/email/send", :body => json_templates_email_send)

        template_messages = []
        (1..25).each do |i|
          template_messages << @template_params
        end

        result = @client.send_messages(@template_key, template_messages)
        result[:statusCode].should == 202
      end

      it "#send_messages with batch size 0" do
        FakeWeb.register_uri(:post, "#{@api_endpoint}/v5/templates/email/send", :body => json_templates_email_send_empty)

        template_messages = []
        result = @client.send_messages(@template_key, template_messages)
        result[:statusCode].should == 202
      end

      it "#send_messages with batch size 26" do
        FakeWeb.register_uri(:post, "#{@api_endpoint}/v5/templates/email/send", :body => json_templates_email_send)

        template_messages = []
        (1..26).each do |i|
          template_messages << @template_params
        end

        expect do
          result = @client.send_messages(@template_key, template_messages)
        end.should raise_error(MessagebusSDK::TemplateError, "Max number of template messages per send exceeded 25")
      end
    end
  end
end