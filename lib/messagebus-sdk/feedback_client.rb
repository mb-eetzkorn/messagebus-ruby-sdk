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

class MessagebusFeedbackClient < MessagebusSDK::MessagebusBase

  def initialize(api_key, api_endpoint = DEFAULT_API_ENDPOINT)
    super(api_key, api_endpoint)
    @rest_endpoints = define_rest_endpoints
  end

  def feedback(start_date = '', end_date = '', scope = SCOPE_ALL, use_send_time = TRUE_VALUE)
    path = "#{@rest_endpoints[:feedback]}#{feedback_query_args(start_date, end_date, use_send_time, scope)}"
    make_api_request(path)
  end

  def feedback_by_channel(channel_key, start_date = '', end_date = '', scope = SCOPE_ALL, use_send_time  = TRUE_VALUE)
    path = "#{replace_channel_key(@rest_endpoints[:feedback_channel], channel_key)}#{feedback_query_args(start_date, end_date, use_send_time, scope)}"
    make_api_request(path)
  end

  def feedback_by_session(channel_key, session_key, start_date = '', end_date = '', scope = SCOPE_ALL, use_send_time  = TRUE_VALUE)
    path = "#{replace_channel_and_session_key(@rest_endpoints[:feedback_session], channel_key, session_key)}#{feedback_query_args(start_date, end_date, use_send_time, scope)}"
    make_api_request(path)
  end

  def unsubs(start_date = '', end_date = '')
    path = "#{@rest_endpoints[:unsubs]}?#{date_range(start_date, end_date)}"
    make_api_request(path)
  end

  def unsubs_by_channel(channel_key, start_date = '', end_date = '')
    path = "#{replace_channel_key(@rest_endpoints[:unsubs_channel], channel_key)}?#{date_range(start_date, end_date)}"
    make_api_request(path)
  end

  def unsubs_by_session(channel_key, session_key, start_date = '', end_date = '')
    path = "#{replace_channel_and_session_key(@rest_endpoints[:unsubs_session], channel_key, session_key)}?#{date_range(start_date, end_date)}"
    make_api_request(path)
  end

  def complaints(start_date = '', end_date = '')
    path = "#{@rest_endpoints[:complaints]}?#{date_range(start_date, end_date)}"
    make_api_request(path)
  end

  def complaints_by_channel(channel_key, start_date = '', end_date = '')
    path = "#{replace_channel_key(@rest_endpoints[:complaints_channel], channel_key)}?#{date_range(start_date, end_date)}"
    make_api_request(path)
  end

  def complaints_by_session(channel_key, session_key, start_date = '', end_date = '')
    path = "#{replace_channel_and_session_key(@rest_endpoints[:complaints_session], channel_key, session_key)}?#{date_range(start_date, end_date)}"
    make_api_request(path)
  end

  def bounces(start_date = '', end_date = '')
    path = "#{@rest_endpoints[:bounces]}?#{date_range(start_date, end_date)}"
    make_api_request(path)
  end

  def bounces_by_channel(channel_key, start_date = '', end_date = '')
    path = "#{replace_channel_key(@rest_endpoints[:bounces_channel], channel_key)}?#{date_range(start_date, end_date)}"
    make_api_request(path)
  end

  def bounces_by_session(channel_key, session_key, start_date = '', end_date = '')
    path = "#{replace_channel_and_session_key(@rest_endpoints[:bounces_session], channel_key, session_key)}?#{date_range(start_date, end_date)}"
    make_api_request(path)
  end

  private

  def define_rest_endpoints
    {
      :feedback => "/api/v4/feedback",
      :feedback_channel => "/api/v4/feedback/channel/%CHANNEL_KEY%",
      :feedback_session => "/api/v4/feedback/channel/%CHANNEL_KEY%/session/%SESSION_KEY%",
      :unsubs => "/api/v4/unsubs",
      :unsubs_channel => "/api/v4/unsubs/channel/%CHANNEL_KEY%",
      :unsubs_session => "/api/v4/unsubs/channel/%CHANNEL_KEY%/session/%SESSION_KEY%",
      :complaints => "/api/v4/complaints",
      :complaints_channel => "/api/v4/complaints/channel/%CHANNEL_KEY%",
      :complaints_session => "/api/v4/complaints/channel/%CHANNEL_KEY%/session/%SESSION_KEY%",
      :bounces => "/api/v4/bounces",
      :bounces_channel => "/api/v4/bounces/channel/%CHANNEL_KEY%",
      :bounces_session => "/api/v4/bounces/channel/%CHANNEL_KEY%/session/%SESSION_KEY%"
    }
  end

end

