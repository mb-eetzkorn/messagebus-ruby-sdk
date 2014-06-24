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

require 'messagebus_base'

class MessagebusReportsClient < MessagebusSDK::MessagebusBase
  FORMAT_JSON = "json"
  FORMAT_CSV = "csv"

  REPORT_TYPE_STATS = "stats"
  REPORT_TYPE_FEEDBACK = "feedback"
  REPORT_TYPE_BLOCKLIST = "blocklist"

  SCOPE_BOUNCES = "bounces"
  SCOPE_UNSUBSCRIBES = "unsubscribes"
  SCOPE_COMPLAINTS = "complaints"
  SCOPE_CLICKS = "clicks"
  SCOPE_OPENS = "opens"
  SCOPE_BLOCKS = "blocks"

  STATUS_DONE = "done"
  STATUS_RUNNING = "running"
  STATUS_NODATA = "nodata"
  STATUS_FAILED = "failed"

  def initialize(api_key, api_endpoint = DEFAULT_API_ENDPOINT)
    super(api_key, api_endpoint)
    @rest_endpoints = define_rest_endpoints
  end

  def report_status(report_key)
    path =  replace_report_key("#{@rest_endpoints[:status]}", report_key)
    make_api_request(path)
  end

  def report_data(report_key, file_name = '')
    path =  replace_report_key("#{@rest_endpoints[:report]}", report_key)
    make_api_request(path, HTTP_GET, '', false, file_name)
  end

  def report(report_key, file_name = '', sleep_interval = 5)
    report_data = ''
    check_report_status = true
    while check_report_status
      response = report_status(report_key)
      case response[:reportStatus]
        when STATUS_DONE
          report_data = report_data(report_key, file_name)
          check_report_status = false
        when STATUS_NODATA, STATUS_FAILED
          report_data = ''
          check_report_status = false
        else
          sleep(sleep_interval)
      end
    end
    return report_data
  end

  def create_report(report_type, start_date, end_date, scope = nil, format = 'json', channel_key = '', session_key = '', use_send_time = true)
    path = @rest_endpoints[:reports]
    days = 1
    end_date = set_date(end_date, 0)
    start_date = set_date(start_date, days)

    post_data = {:reportType => report_type,
                 :format => format,
                 :startDate => start_date,
                 :endDate => end_date,
                 :channelKey => channel_key,
                 :sessionKey => session_key
                }

    post_data[:scope] = scope if (report_type == REPORT_TYPE_FEEDBACK || report_type == REPORT_TYPE_BLOCKLIST)
    post_data[:useSendTime] = use_send_time if report_type == REPORT_TYPE_FEEDBACK

    make_api_request(path, HTTP_POST, post_data.to_json)
  end

  def create_feedback_report(start_date, end_date, scope = 'bounces', format = 'json', channel_key = '', session_key = '', use_send_time = true)
    create_report(REPORT_TYPE_FEEDBACK, start_date, end_date, scope, format, channel_key, session_key, use_send_time)
  end

  def create_stats_report(start_date, end_date, format = 'json', channel_key = '', session_key = '')
    create_report(REPORT_TYPE_STATS, start_date, end_date, nil, format, channel_key, session_key)
  end

  def create_blocklist_report(start_date, end_date, scope = 'blocks', format = 'json', channel_key = '', session_key = '')
    create_report(REPORT_TYPE_BLOCKLIST, start_date, end_date, scope, format, channel_key, session_key)
  end

  private

  def define_rest_endpoints
    {
      :reports => "/v5/reports",
      :report => "/v5/report/%REPORT_KEY%",
      :status => "/v5/report/%REPORT_KEY%/status"
    }
  end
end

