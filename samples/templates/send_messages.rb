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

require 'messagebus-sdk/template_client'

api_key = "12345678934628542E2599F7ED712345"
api_host = "https://templates-v4-jy01-prod.messagebus.com"

client = MessagebusTemplateClient.new(api_key, api_host)

template_key = "6226821c-3407-430d-8db2-df21405abf28"

session_key = "DEFAULT";
template_params = [
    {"rcpt_email" => "bob@example.com",
     "rcpt_name" => "Bob",
     "subject" => "Sample Message with HTML body.",
     "text_value" => "test #1",
     "sender_email" => "alice@example.com",
     "sender_name" => "Alice Waters",
     "sessionKey" => session_key},
    {"rcpt_email" => "jane@example.com",
     "rcpt_name" => "Jane",
     "subject" => "Sample Message with HTML body.",
     "text_value" => "test #2",
     "sender_email" => "alice@example.com",
     "sender_name" => "Alice Waters",
     "sessionKey" => session_key}
]

begin
  response = client.send_messages(template_key, template_params)
  if response[:statusCode] == 202
    puts "Email send results"

    response[:results].each do |message|
      puts "To: #{message[:toEmail]} Message Id: #{message[:messageId]} Message Status: #{message[:messageStatus]}"
    end
  else
    puts "#{response[:statusMessage]}"
  end
rescue Exception=>e
  puts "Exception thrown.  Error during template email send: #{e.message}"
end


