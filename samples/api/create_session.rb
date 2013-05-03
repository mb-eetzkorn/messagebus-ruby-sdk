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

require 'messagebus-sdk/api_client'

api_key="12345678934628542E2599F7ED712345"
api_host="https://api-v4.messagebus.com"

channel_key = "c485d2ed5cc4ce64fcccca710c7a0bb7"
session_name = "Session Name"

client = MessagebusApiClient.new(api_key, api_host)

begin
  result = client.channel_create_session(channel_key, session_name)
  puts "Successfully created session #{result[:sessionKey]} with name #{result[:sessionName]}"
rescue Exception=>e
  puts "Exception thrown.  Error during session creation: #{e.message}"
end
