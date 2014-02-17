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

require 'messagebus-sdk/reports_client'

#api_key="12345678934628542E2599F7ED712345"
#api_host="https://api.messagebus.com"

api_key="9CVFCzCSCtQuNJGkUGUnwCz0NwLYeAa2"
api_host="https://api.messagebus.com"


client = MessagebusReportsClient.new(api_key, api_host)

begin
  start_date = (Time.now.utc - (2 * 86400)).strftime("%Y-%m-%dT%H:%M:%SZ")
  end_date = Time.now.utc.strftime("%Y-%m-%dT%H:%M:%SZ")

  response = client.create_stats_report(start_date, end_date)
  report_key = response[:reportKey]

  response = client.report(report_key)

  # Output to STDOUT
  puts response

rescue Exception=>e
  puts "Exception thrown.  Error during stats report creation: #{e.message}"
end
