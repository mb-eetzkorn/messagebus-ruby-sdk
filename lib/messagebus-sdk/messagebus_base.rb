# Copyright 2014 Message Bus
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
require 'json'
require 'net/http'
require 'messagebus_version'
require 'messagebus_errors'


module MessagebusSDK

  class MessagebusBase
    DEFAULT_API_ENDPOINT = 'https://api.messagebus.com'
    DEFAULT = 'DEFAULT'
    HEADER_SESSION_KEY = 'X-MESSAGEBUS-SESSIONKEY'
    SCOPE_ALL = 'all'
    TRUE_VALUE = 'true'
    MAX_TEMPLATE_MESSAGES = 25

    HTTP_GET = "GET"
    HTTP_POST = "POST"
    HTTP_PUT = "PUT"
    HTTP_DELETE = "DELETE"

    def initialize(api_key, api_endpoint = DEFAULT_API_ENDPOINT)
      @api_endpoint = api_endpoint
      @api_key = api_key
      init_http_connection(@api_endpoint)

      @results = base_response_params
      @rest_http_errors = define_rest_http_errors
      @return_json = true
      @file_handle = nil
    end

    def api_version
      make_api_request("/api/version")
    end

    def cacert_info(cert_file)
      @http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      if !File.exists?(cert_file)
        raise MessagebusSDK::MissingFileError.new("Unable to read file #{cert_file}")
      end
      @http.ca_file = File.join(cert_file)
    end

    def format_iso_time(time)
      time.strftime("%Y-%m-%dT%H:%M:%SZ")
    end

    private

    def init_http_connection(target_server)
      if (@http and @http.started?)
        @http.finish
      end
      @last_init_time = Time.now.utc
      endpoint_url = URI.parse(target_server)
      @http = Net::HTTP.new(endpoint_url.host, endpoint_url.port)
      @http.use_ssl = true
      @http.read_timeout = 300
      @http
    end

    def common_http_headers
      {'User-Agent' => MessagebusSDK::Info.get_user_agent, 'X-MessageBus-Key' => @api_key}
    end

    def rest_post_headers
      {"Content-Type" => "application/json; charset=utf-8"}
    end

    def date_range(start_date, end_date)
      date_range_str=""
      if (start_date!="")
        date_range_str+="startDate=#{start_date}"
      end
      if (end_date!="")
        if (date_range_str!="")
          date_range_str+="&"
        end
        date_range_str+="endDate=#{end_date}"
      end
      date_range_str
    end

    def set_date(date_string, days_ago)
      if date_string.length == 0
        return date_str_for_time_range(days_ago)
      end
      date_string
    end

    def date_str_for_time_range(days_ago)
      format_iso_time(Time.now.utc - (days_ago*86400))
    end

    def well_formed_address?(address)
      !address.match(/^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i).nil?
    end

    def make_api_request(path, request_type=HTTP_GET, data='', return_json = true, file_name='')
      if (@last_init_time < Time.now.utc - 60)
        init_http_connection(@api_endpoint)
      end

      @return_json = return_json
      headers = common_http_headers
      case request_type
        when HTTP_GET
          if !@return_json && file_name != ''
            response_file = open(file_name, 'w')
            @http.request_get(path, headers) do |response|
              response.read_body do |segment|
                response_file.write(segment)
              end
            end
            response_file.close
            return true
          else
            response = @http.request_get(path, headers)
          end
        when HTTP_PUT
          headers = common_http_headers.merge(rest_post_headers)
          response = @http.request_put(path, data, headers)
        when HTTP_POST
          headers = common_http_headers.merge(rest_post_headers)
          response = @http.request_post(path, data, headers)
        when HTTP_DELETE
          response = @http.delete(path, headers)
      end
      check_response(response)
    end

    def check_response(response, symbolize_names=true)
      return response.body if !@return_json
      case response
        when Net::HTTPSuccess
          begin
            return JSON.parse(response.body, :symbolize_names => symbolize_names)
          rescue JSON::ParserError => e
            raise MessagebusSDK::RemoteServerError.new("JSON parsing error.  Response started with #{response.body.slice(0..9)}")
          end
        when Net::HTTPClientError, Net::HTTPServerError
          if (response.body && response.body.size > 0)
            result = begin
              JSON.parse(response.body, :symbolize_names => symbolize_names)
            rescue JSON::ParserError
              nil
            end
            raise MessagebusSDK::RemoteServerError.new("#{response.code.to_s}:#{rest_http_error_message(response)}")
          else
            raise MessagebusSDK::RemoteServerError.new("#{response.code.to_s}:#{rest_http_error_message(response)}")
          end
        else
          raise "Unexpected HTTP Response: #{response.class.name}"
      end
      raise "Could not determine response"
    end

    def rest_http_error?(status_code)
      @rest_http_errors.key?(status_code)
    end

    def rest_http_error_message(response)
      message = "Unknown Error Code"
      message = @rest_http_errors[response.code.to_s] if rest_http_error?(response.code.to_s)
      if (response.body.size > 0)
        values = JSON.parse(response.body)

        if (values['statusMessage'])
          message += " - " + values['statusMessage']
        end
      end
      message
    end

    def replace_token_with_key(path, token, key)
      path.gsub(token, key)
    end

    def replace_channel_key(path, channel_key)
      replace_token_with_key(path, "%CHANNEL_KEY%", channel_key)
    end

    def replace_channel_and_session_key(path, channel_key, session_key)
      replace_channel_key(replace_token_with_key(path, "%SESSION_KEY%", session_key), channel_key)
    end

    def replace_webhook_key(path, webhook_key)
      replace_token_with_key(path, "%WEBHOOK_KEY%", webhook_key)
    end

    def replace_report_key(path, report_key)
      replace_token_with_key(path, "%REPORT_KEY%", report_key)
    end

    def feedback_query_args(start_date, end_date, use_send_time, scope)
      query_string_parts = ["useSendTime=#{use_send_time}", "scope=#{scope}"]
      date_range = "#{date_range(start_date, end_date)}"
      query_string_parts << date_range if date_range != ""
      "?" + query_string_parts.join("&")
    end

    def underscore(camel_cased_word)
       camel_cased_word.to_s.gsub(/::/, '/').
         gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
         gsub(/([a-z\d])([A-Z])/,'\1_\2').
         tr("-", "_").
         downcase
     end

    def snake_case
      return downcase if match(/\A[A-Z]+\z/)
      gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').
      gsub(/([a-z])([A-Z])/, '\1_\2').
      downcase
    end

    def define_rest_http_errors
      {
        "400" => "Invalid Request",
        "401" => "Unauthorized-Missing API Key",
        "403" => "Unauthorized-Invalid API Key",
        "404" => "Incorrect URL",
        "405" => "Method not allowed",
        "406" => "Format not acceptable",
        "408" => "Request Timeout",
        "409" => "Conflict",
        "410" => "Object missing or deleted",
        "413" => "Too many messages in request",
        "415" => "POST JSON data invalid",
        "422" => "Unprocessable Entity",
        "500" => "Internal Server Error",
        "501" => "Not Implemented",
        "503" => "Service Unavailable",
        "507" => "Insufficient Storage"
      }
    end

    def base_response_params
      {:statusCode => 0,
       :statusMessage => "",
       :statusTime => "1970-01-01T00:00:00.000Z"}
    end

    def base_message_params
      {:toEmail => '',
       :fromEmail => '',
       :subject => '',
       :toName => '',
       :fromName => '',
       :plaintextBody => '',
       :htmlBody => '',
       :sessionKey => DEFAULT,
       :customHeaders => {} }
    end

  end
end
