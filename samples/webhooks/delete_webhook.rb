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

require 'messagebus-sdk/webhook_client'

api_key="12345678934628542E2599F7ED712345"
api_host="https://api.messagebus.com"

client = MessagebusWebhookClient.new(api_key, api_host)

begin
  webhook_key = '2ff80e9159b517704ce43f0f74e6e247'
  result = client.delete(webhook_key)
  if result[:statusCode] == 200
    puts "Successfully deleted webhook #{webhook_key}"
  else
    puts result[:statusMessage]
  end
rescue Exception=>e
  puts "Exception thrown.  Error during webhook deletion: #{e.message}"
end
