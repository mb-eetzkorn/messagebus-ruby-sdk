# Copyright 2013 Message Bus, Inc.
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

require 'messagebus_base'

class MessagebusApiClient < MessagebusSDK::MessagebusBase

  def initialize(api_key, api_endpoint = DEFAULT_API_ENDPOINT)
    super(api_key, api_endpoint)
    @rest_endpoints = define_rest_endpoints
  end

  def send_messages(params)
    path =  @rest_endpoints[:message_emails_send]
    json = {:messages => params}.to_json
    make_api_request(path, HTTP_POST, json)
  end

  def channels
    path = "#{@rest_endpoints[:channels]}"
    make_api_request(path, HTTP_GET)
  end

  def channel_config(channel_key)
    path =  replace_channel_key("#{@rest_endpoints[:channel_config]}", channel_key)
    make_api_request(path, HTTP_GET)
  end

  def channel_sessions(channel_key)
    path =  replace_channel_key("#{@rest_endpoints[:channel_sessions]}", channel_key)
    make_api_request(path, HTTP_GET)
  end

  def channel_create_session(channel_key, session_name)
    path =  replace_channel_key("#{@rest_endpoints[:channel_sessions]}", channel_key)
    json = {:sessionName => session_name}.to_json
    make_api_request(path, HTTP_POST, json)
  end

  def channel_rename_session(channel_key, session_key, session_name)
    path = replace_channel_and_session_key("#{@rest_endpoints[:channel_session_rename]}", channel_key, session_key)
    json = {:sessionName => session_name}.to_json
    make_api_request(path, HTTP_PUT, json)
  end

  private

  def define_rest_endpoints
    {
      :message_emails_send => "/api/v4/message/email/send",
      :channels => "/api/v4/channels",
      :channel_config => "/api/v4/channel/%CHANNEL_KEY%/config",
      :channel_sessions => "/api/v4/channel/%CHANNEL_KEY%/sessions",
      :channel_session_rename => "/api/v4/channel/%CHANNEL_KEY%/session/%SESSION_KEY%/rename"
    }
  end
end

