
dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/../../lib/messagebus-sdk/messagebus_base"

class MessagebusTest < MessagebusSDK::MessagebusBase
  def get_test(path)
    make_api_request(path, HTTP_GET)
  end

  def post_test(path, data)
    make_api_request(path, HTTP_POST, data)
  end

  def put_test(path, data)
    make_api_request(path, HTTP_PUT, data)
  end

  def delete_test(path)
    make_api_request(path, HTTP_DELETE)
  end
end

describe MessagebusSDK::MessagebusBase do

  before do
    FakeWeb.allow_net_connect = false
    @api_key = "7215ee9c7d9dc229d2921a40e899ec5f"
  end

  describe "messagebus base object set up correctly" do
    it "has correct headers and accepts a custom endpoint" do
      test_endpoint = 'https://testapi-v4.messagebus.com/api/v4'
      client = MessagebusSDK::MessagebusBase.new(@api_key, test_endpoint)
      client.instance_eval('@http').address.should == "testapi-v4.messagebus.com"
    end
  end

  describe "add cacert file to http communitcations" do
    it "raises error if cert file does not exist" do
      client = MessagebusSDK::MessagebusBase.new(@api_key)
      cert_file_path = File.join(File.dirname(__FILE__), "nofile.pem")
      expect do
        client.cacert_info(cert_file_path)
      end.should raise_error
    end

    it "accepts a cert file that exists" do
      client = MessagebusSDK::MessagebusBase.new(@api_key)
      cert_file_path = File.join(File.dirname(__FILE__), "cacert.pem")
      expect do
        client.cacert_info(cert_file_path)
      end.should_not raise_error
    end
  end

  # TODO http testing for correct VERB
  describe "#make_api_request" do
    before do
      @client = MessagebusTest.new(@api_key)
    end
    it "GET" do
      path = "#{API_URL}/get_test"
      FakeWeb.register_uri(:get, path, :body => json_simple_response)
      @client.get_test(path)

      request = FakeWeb.last_request
      request.method.should == "GET"
      request.body.should be_nil
      request.each_header do |key, value|
        case key
          when "user-agent"
            value.should =~ /^MessagebusAPI*/
          when "x-messagebus-key"
            value.should == @api_key
        end
      end
    end

    it "POST" do
      path = "#{API_URL}/post_test"
      data = "{\"json\":\"data\"}"
      FakeWeb.register_uri(:post, path, :body => json_simple_response)
      @client.post_test(path, data)

      request = FakeWeb.last_request
      request.method.should == "POST"
      request.body.should == data
      request.each_header do |key, value|
        case key
          when "user-agent"
            value.should =~ /^MessagebusAPI*/
          when "x-messagebus-key"
            value.should == @api_key
          when "content-type"
            value.should == "application/json; charset=utf-8"
        end
      end
    end

    it "PUT" do
      path = "#{API_URL}/put_test"
      data = "{\"json\":\"data\"}"
      FakeWeb.register_uri(:put, path, :body => json_simple_response)
      @client.put_test(path, data)

      request = FakeWeb.last_request
      request.method.should == "PUT"
      request.body.should == data
      request.each_header do |key, value|
        case key
          when "user-agent"
            value.should =~ /^MessagebusAPI*/
          when "x-messagebus-key"
            value.should == @api_key
          when "content-type"
            value.should == "application/json; charset=utf-8"
        end
      end
    end

    it "DELETE" do
      path = "#{API_URL}/delete_test"
      FakeWeb.register_uri(:delete, path, :body => json_simple_response)
      @client.delete_test(path)

      request = FakeWeb.last_request
      request.method.should == "DELETE"
      request.body.should be_nil
      request.each_header do |key, value|
        case key
          when "user-agent"
            value.should =~ /^MessagebusAPI*/
          when "x-messagebus-key"
            value.should == @api_key
        end
      end
    end
  end

  describe "#version" do
    it "retrieves the current version of the API" do
      FakeWeb.register_uri(:get, "https://api-v4.messagebus.com/api/version", :body => json_api_version_results)
      client = MessagebusSDK::MessagebusBase.new(@api_key)
      version = client.api_version

      version[:statusCode].should == 200
      version[:APIVersion].length.should > 0
    end
  end
end