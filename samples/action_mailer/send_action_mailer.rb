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

require 'action_mailer'
require 'messagebus-sdk/actionmailer_client'

# Declare mailer with API Key
class MessagebusMailer < MessagebusActionMailerClient
  def initialize(*args)
    api_key = "12345678934628542E2599F7ED712345"
    api_endpoint = "https://api.messagebus.com"
    super(api_key, api_endpoint)
  end
end

# Assign action_mailer to the correct delivery method
ActionMailer::Base.add_delivery_method :messagebus, MessagebusMailer
ActionMailer::Base.delivery_method = :messagebus

# Methods to create and send mail
class MessageBusActionMailerTest < ActionMailer::Base
  default :from => "no-reply@messagebus.com",
          :body => "This is a test",
          :subject => "Unit Test",
          :return_path => "bounce@bounces.example.com"

  def test_message(to_email, session_key)
    headers[MessagebusSDK::MessagebusBase::HEADER_SESSION_KEY] = session_key
    mail(:to => to_email)
  end
end

to_email = "hello@example.com"
session_key = "DEFAULT"
message = MessageBusActionMailerTest.test_message(to_email, session_key)
message.deliver

puts "Message delivered to #{to_email}"
