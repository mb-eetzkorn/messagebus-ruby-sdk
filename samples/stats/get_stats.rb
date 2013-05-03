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

require 'messagebus-sdk/stats_client'

api_key = "12345678934628542E2599F7ED712345"
api_host = "https://api-v4.messagebus.com"

client = MessagebusStatsClient.new(api_key, api_host)

begin
  response = client.stats
  if response[:statusCode] == 200
    stats = response[:stats]
    puts "Stats"
    puts "\tMessages Attempted: #{stats[:msgsAttemptedCount]}"
    puts "\tComplaint Count: #{stats[:complaintCount]}"
    puts "\tUnsubscribe Count: #{stats[:unsubscribeCount]}"
    puts "\tOpen Count: #{stats[:openCount]}"
    puts "\tUnique Open Count: #{stats[:uniqueOpenCount]}"
    puts "\tClick Count: #{stats[:clickCount]}"

    smtp = response[:smtp]
    puts "SMTP"
    puts "\tAccept Count: #{smtp[:acceptCount]}"
    puts "\tBounce Count: #{smtp[:bounceCount]}"
    puts "\tReject Count: #{smtp[:rejectCount]}"
    puts "\tError Count: #{smtp[:errorCount]}"

    filter = response[:filter]
    puts "Filter"
    puts "\tBad Mailbox Count: #{filter[:rcptBadMailboxCount]}"
    puts "\tChannel Block Count: #{filter[:rcptChannelBlockCount]}"

  else
    puts "#{response[:statusMessage]}"
  end
rescue Exception=>e
  puts "Exception thrown.  Error during stats retrieval: #{e.message}"
end

