
dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/../../lib/messagebus-sdk/reports_client"

describe MessagebusReportsClient do
  attr_reader :client, :api_key

  before do
    FakeWeb.allow_net_connect = false
    @api_key = "7215ee9c7d9dc229d2921a40e899ec5f"
    @client = MessagebusReportsClient.new(@api_key)
  end

  describe "reports" do
    it "#report_status" do
      report_key = '125a58512d8446279e3530c8d803f5e2'
      expected_request="#{API_URL}/report/#{report_key}/status"
      FakeWeb.register_uri(:get, expected_request, :body => json_report_status_request_response_done200)

      response = client.report_status(report_key)
      response.should == json_parse(json_report_status_request_response_done200)
    end

    it "#report_data" do
      report_key = '125a58512d8446279e3530c8d803f5e2'
      expected_request="#{API_URL}/report/#{report_key}/status"
      FakeWeb.register_uri(:get, expected_request, :body => json_report_status_request_response_done200)

      response = client.report_status(report_key)
      response.should == json_parse(json_report_status_request_response_done200)
    end

    it "#report" do
      report_key = '125a58512d8446279e3530c8d803f5e2'
      expected_request="#{API_URL}/report/#{report_key}/status"
      FakeWeb.register_uri(:get, expected_request, :body => json_report_status_request_response_done200)

      expected_request="#{API_URL}/report/#{report_key}"
      FakeWeb.register_uri(:get, expected_request, :body => json_report_request_data_bounce)

      response = client.report(report_key)
    end

    it "#create_report" do
      #def create_report(report_type, start_date, end_date, scope = 'bounces', format = 'json', channel_key = '', session_key = '')
      report_type = MessagebusReportsClient::REPORT_TYPE_STATS
      start_date_str="2014-01-01"
      end_date_str="2014-01-02"
      scope = MessagebusReportsClient::SCOPE_BOUNCES
      format = MessagebusReportsClient::FORMAT_CSV

      post_data = {:reportType => report_type,
                   :scope => scope,
                   :format => format,
                   :startDate => start_date_str,
                   :endDate => end_date_str,
                   :channelKey => '',
                   :sessionKey => ''
                  }

      expected_request="#{API_URL}/reports"
      FakeWeb.register_uri(:post, expected_request, :body => json_report_request_response201)

      response = client.create_report(report_type, start_date_str, end_date_str, scope, format)
      FakeWeb.last_request.body.should == post_data.to_json
    end

    it "#create_feedback_report" do
      start_date_str="2014-01-01"
      end_date_str="2014-01-02"
      scope = MessagebusReportsClient::SCOPE_BOUNCES
      format = MessagebusReportsClient::FORMAT_CSV

      post_data = {:reportType => MessagebusReportsClient::REPORT_TYPE_FEEDBACK,
                   :scope => scope,
                   :format => format,
                   :startDate => start_date_str,
                   :endDate => end_date_str,
                   :channelKey => '',
                   :sessionKey => ''
                  }

      expected_request="#{API_URL}/reports"
      FakeWeb.register_uri(:post, expected_request, :body => json_report_request_response201)
      response = client.create_feedback_report(start_date_str, end_date_str, scope, format)
      FakeWeb.last_request.body.should == post_data.to_json
    end

    it "#create_stats_report" do
      start_date_str="2014-01-01"
      end_date_str="2014-01-02"
      format = MessagebusReportsClient::FORMAT_CSV

      post_data = {:reportType => MessagebusReportsClient::REPORT_TYPE_STATS,
                   :scope => MessagebusReportsClient::SCOPE_ALL,
                   :format => format,
                   :startDate => start_date_str,
                   :endDate => end_date_str,
                   :channelKey => '',
                   :sessionKey => ''
                  }

      expected_request="#{API_URL}/reports"
      FakeWeb.register_uri(:post, expected_request, :body => json_report_request_response201)
      response = client.create_stats_report(start_date_str, end_date_str, format)
      FakeWeb.last_request.body.should == post_data.to_json

    end

    it "#create_blocklist_report" do
      start_date_str="2014-01-01"
      end_date_str="2014-01-02"
      scope = MessagebusReportsClient::SCOPE_BLOCKS
      format = MessagebusReportsClient::FORMAT_CSV

      post_data = {:reportType => MessagebusReportsClient::REPORT_TYPE_BLOCKLIST,
                   :scope => scope,
                   :format => format,
                   :startDate => start_date_str,
                   :endDate => end_date_str,
                   :channelKey => '',
                   :sessionKey => ''
                  }

      expected_request="#{API_URL}/reports"
      FakeWeb.register_uri(:post, expected_request, :body => json_report_request_response201)
      response = client.create_blocklist_report(start_date_str, end_date_str, scope, format)
      FakeWeb.last_request.body.should == post_data.to_json
    end
  end
end