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
  params = {:enabled => false,
            :uri => 'http://domain.com/events/messagebus/message.accept',
            :eventType => MessagebusWebhookClient::EVENT_TYPE_MESSAGE_ACCEPT
           }

  result = client.create(params)
  if result[:statusCode] == 201
    puts "Successfully created webhook with key #{result[:webhookKey]}"

    # List webhooks for account
    result = client.webhooks
    puts "Webhooks for account:"
    result[:webhooks].each do |webhook|
      puts "Enabled: #{webhook[:enabled]} Key: #{webhook[:webhookKey]} Event Type: #{webhook[:eventType]} URI: #{webhook[:uri]}"
    end
  else
    puts result[:statusMessage]
  end
rescue Exception=>e
  puts "Exception thrown.  Error during webhook creation: #{e.message}"
end
