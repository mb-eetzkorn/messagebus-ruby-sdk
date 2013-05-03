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

client = MessagebusApiClient.new(api_key, api_host)

session_key = "DEFAULT"

messages = [
    {:toEmail => 'bobby@example.com',
     :toName => 'Bobby Flay',
     :fromEmail => 'alice@example.com',
     :fromName => 'Alice Waters',
     :subject => 'Sample Message with HTML body.',
     :customHeaders => {"x-messagebus-sdk"=>"ruby-sdk"},
     :plaintextBody => 'This is the plain text body.',
     :htmlBody => 'This is the <b>HTML</b>body.',
     :sessionKey => session_key},
    {:toEmail => 'jamie@example.com',
     :toName => 'Jamie Lauren',
     :fromEmail => 'alice@example.com',
     :fromName => 'Alice Waters',
     :subject => 'Simple Example with no HTML body.',
     :customHeaders => {"x-messagebus-sdk"=>"ruby-sdk"},
     :plaintextBody => 'This is the plaintext example.',
     :sessionKey => session_key}
  ]

begin
  response = client.send_messages(messages)
  if response[:statusCode] == 202
    puts "Email send results"
    response[:results].each do |message|
      puts "To: #{message[:toEmail]} Message Id: #{message[:messageId]} Message Status: #{message[:messageStatus]}"
    end
  else
    puts "#{response[:statusMessage]}"
  end
rescue Exception=>e
  puts "Exception thrown.  Error during send: #{e.message}"
end



