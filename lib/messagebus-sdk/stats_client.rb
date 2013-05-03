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

class MessagebusStatsClient < MessagebusSDK::MessagebusBase

  def initialize(api_key, api_endpoint = DEFAULT_API_ENDPOINT)
    super(api_key, api_endpoint)
    @rest_endpoints = define_rest_endpoints
  end

  def stats(start_date = '', end_date = '')
    path = "#{@rest_endpoints[:stats]}?#{date_range(start_date, end_date)}"
    make_api_request(path)
  end

  def stats_by_channel(channel_key, start_date = '', end_date = '')
    path = "#{replace_channel_key(@rest_endpoints[:stats_channel], channel_key)}?#{date_range(start_date, end_date)}"
    make_api_request(path)
  end

  def stats_by_session(channel_key, session_key, start_date = '', end_date = '')
    path = "#{replace_channel_and_session_key(@rest_endpoints[:stats_session], channel_key, session_key)}?#{date_range(start_date, end_date)}"
    make_api_request(path)
  end

  private

  def define_rest_endpoints
    {
      :stats => "/api/v4/stats/email",
      :stats_channel => "/api/v4/stats/email/channel/%CHANNEL_KEY%",
      :stats_session => "/api/v4/stats/email/channel/%CHANNEL_KEY%/session/%SESSION_KEY%",
    }
  end

end

