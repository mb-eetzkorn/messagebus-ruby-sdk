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

require 'messagebus-sdk/feedback_client'

api_key = "12345678934628542E2599F7ED712345"
api_host = "https://api-v4.messagebus.com"

client = MessagebusFeedbackClient.new(api_key, api_host)

begin
  response = client.feedback
  if response[:statusCode] == 200
    puts "Bounces"
    response[:bounces].each do |bounce|
      puts "Email: #{bounce[:email]} Count: #{bounce[:count]} BounceCode: #{bounce[:bounceCode]} LastEventTime: #{bounce[:lastEventTime]}"
    end
    puts "Clicks"
    response[:clicks].each do |click|
      puts "Email: #{click[:email]} Count: #{click[:count]} LastEventTime: #{click[:lastEventTime]}"
    end
  else
    puts "#{response[:statusMessage]}"
  end
rescue Exception=>e
  puts "Exception thrown.  Error during feedback retrieval: #{e.message}"
end
