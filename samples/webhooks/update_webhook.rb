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
  params = {:uri => 'http://domain.com/events/messagebus/message.accepted'}

  webhook_key = 'A130B7ACAD6E45BDB00CA1B96B1CC824'

  result = client.update(webhook_key, params)
  if result[:statusCode] == 200
    puts "Webhook current settings:"
    result = client.webhook(webhook_key)
    webhook = result[:webhook]
    puts "Key : #{webhook[:webhookKey]}"
    puts "Enabled : #{webhook[:enabled]}"
    puts "Event Type : #{webhook[:eventType]}"
    puts "URI : #{webhook[:uri]}"
    puts "Last Update : #{webhook[:lastUpdated]}"
    puts "Created On : #{webhook[:dateCreated]}"
    puts "Batching - Enabled : #{webhook[:batching][:batchingEnabled]}"
    puts "         - Time (s): #{webhook[:batching][:batchTimeSeconds]}"
    puts "         - Size    : #{webhook[:batching][:maxBatchSize]}"
  else
    puts result[:statusMessage]
  end
rescue Exception=>e
  puts "Exception thrown.  Error during webhook update: #{e.message}"
end
