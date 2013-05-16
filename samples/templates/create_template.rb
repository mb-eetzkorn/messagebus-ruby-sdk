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

test_template = {
    :toName => "{{rcpt_name}}",
    :toEmail => "{{rcpt_email}}",
    :fromName => "{{sender_name}}",
    :fromEmail => "{{sender_email}}",
    :returnPath => "bounces@bounces.example.com",
    :subject => "Hello {{{rcpt_name}}}",
    :plaintextBody => "This is the plaintextBody! This is a {{text_value}}",
    :htmlBody => "<p>This is the htmlBody!</p>",
    :sessionKey => "{{session_key}}",
    :customHeaders => {"X-MessageBus-SDK" => "messagebus-ruby-sdk"}
}

begin
  response = client.create_template(test_template)
  if response[:statusCode] == 201
    puts "Template created with key: #{response[:templateKey]}"

    puts "Templates associated with this account:"
    result = client.templates
    result[:templates].each do |template|
      puts "TemplateKey: #{template[:templateKey]}"
    end
  else
    puts "#{response[:statusMessage]}"
  end
rescue Exception=>e
  puts "Exception thrown.  Error during template creation: #{e.message}"
end

