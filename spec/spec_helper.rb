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

dir = File.dirname(__FILE__)

require 'rubygems'
require 'fakeweb'
require 'rr'
require 'json'
require 'action_mailer'
require "#{dir}/spec_core_extensions"
$LOAD_PATH << "#{dir}/../lib/messagebus-sdk"
require 'messagebus_base'
require 'api_client'
require 'actionmailer_client'
require 'messagebus_errors'

API_URL = 'https://api.messagebus.com/v5'

def json_parse(data)
  JSON.parse(data, :symbolize_names => true)
end

def json_api_version_results
  json = <<JAVASCRIPT
{"statusCode":200,"statusMessage":"API Version Lookup","statusTime":"2013-03-11T06:16:06.401Z","APIName":"api","APIVersion":"1.1.13.6-final-201302262055"}
JAVASCRIPT
  json
end

def json_template_version_results
  json = <<JAVASCRIPT
{"statusCode":200,"statusMessage":"9bdefe3cdcbc97a226c68e2784871f3f5b103c2e","version":"1.2.1","statusTime":"2013-05-02T18:20:32.782Z"}
JAVASCRIPT
  json
end

def json_simple_response
  json = <<JAVASCRIPT
{"statusCode":202,"statusMessage":"OK","statusTime":"2011-10-10T21:32:14.195Z"}
JAVASCRIPT
  json
end

def json_valid_send
  json = <<JAVASCRIPT
{"statusCode":202,"statusMessage":"OK","statusTime":"2011-10-10T21:32:14.195Z","successCount":1,"failureCount":0,"results":[{"toEmail":"apitest1@messagebus.com","messageId":"51efcf00f38711e0a93640405cc99fee","messageStatus":0}]}
JAVASCRIPT
  json
end

def json_incomplete_results
  json = <<JAVASCRIPT
{"statusCode":202}
JAVASCRIPT
  json
end

def json_invalid_results
  json = <<JAVASCRIPT
GARBAGE_JSON
JAVASCRIPT
  json
end

def json_channels
  json = <<JAVASCRIPT
{"statusCode":200,"statusMessage":"","statusTime":"2011-10-10T21:32:14.195Z",
"results":[
    {"channelName":"channel1","channelKey":"ab487e9d750a3c50876d12e8f381a79f","defaultSessionKey":"43fd828731048cda3a0a050b22bed4f3","isDefault":true},
    {"channelName":"channel2","channelKey":"9ebd88e34d0e74178cab184e781bafb5","defaultSessionKey":"98432f23b96c8138c2606ef8bebc0a82","isDefault":false}
]}
JAVASCRIPT
  json
end

def json_channel_config
  json = <<JAVASCRIPT
{"statusCode":200,"statusMessage":"","statusTime":"2011-10-10T21:32:14.195Z",
"configuration":{
    "addOpenRate":true,
    "openRateCustomDomain":"or.sample.com",
    "addUnsubscribe":true,
    "openRateCustomDomain":"unsub.sample.com",
    "addClickDetection":true,
    "openRateCustomDomain":"cd.sample.com"
}}
JAVASCRIPT
  json
end

def json_channel_sessions
  json = <<JAVASCRIPT
{"statusCode":200,"statusMessage":"","statusTime":"2011-10-10T21:32:14.195Z","count":2
"results":[
    {"sessionKey":"43fd828731048cda3a0a050b22bed4f3","sessionName":"session1","isDefault":true},
    {"sessionKey":"98432f23b96c8138c2606ef8bebc0a82","sessionName":"session2","isDefault":true}
]}
JAVASCRIPT
  json
end

def json_channel_create_session
  json = <<JAVASCRIPT
{"statusCode":200,"statusMessage":"","statusTime":"2011-10-10T21:32:14.195Z",
 "sessionName":"new_session",
 "sessionKey":"d2028fa69e46d53d76a84ef13d8d1bb7"
}
JAVASCRIPT
  json
end

def json_channel_rename_session
  json = <<JAVASCRIPT
{"statusCode":200,"statusMessage":"","statusTime":"2011-10-10T21:32:14.195Z",
 "sessionName":"rename_session",
 "sessionKey":"b9c8c04f56e580af6d766419bf1f0716"
}
JAVASCRIPT
  json
end

def json_unsubs
  json = <<JAVASCRIPT
{"statusCode":200,"statusMessage":"","statusTime":"2011-10-10T21:32:14.195Z",
 "unsubs":[
    {"email":"joe@example.com","count":2},
    {"email":"jane@example.com","count":1}
]}
JAVASCRIPT
  json
end

def json_complaints
  json = <<JAVASCRIPT
{"statusCode":200,"statusMessage":"","statusTime":"2011-10-10T21:32:14.195Z",
 "complaints":[
    {"email":"joe@example.com","count":2},
    {"email":"jane@example.com","count":1}
]}
JAVASCRIPT
  json
end

def json_feedback(scope)
  json = <<JAVASCRIPT
{"accountId":"2", "channelId":"", "sessionId":"", "startDate":1361908365183, "endDate":1361994765183, "scope":"#{scope}", "useSendTime":"true", "bounces":[], "complaints":[], "unsubscribes":[], "opens":[], "clicks":[], "statusCode":200, "statusMessage":"", "statusTime":"2013-02-27T19:52:45.696Z"}
JAVASCRIPT
end

def json_stats
  json = <<JAVASCRIPT
{"statusCode":200,"statusMessage":"","statusTime":"2011-10-10T21:32:14.195Z",
 "stats":
        {"msgAttemptedCount":0, "complaintCount":0,"unsubscribeCount":0,"openCount":0},
 "smtp":
        {"acceptCount":0, "bounceCount":0,"deferralCount":0,"rejectCount":0, "errorCount":0},
 "filter":
        {"rcptBadMailboxCount":0,"rcptChannelBlockCount":0}
}
JAVASCRIPT
  json
end

def json_response_201
  json = <<JAVASCRIPT
{"statusCode":201,"statusMessage":"","statusTime":"2011-10-10T21:32:14.195Z"}
JAVASCRIPT
  json
end

def json_response_200
  json = <<JAVASCRIPT
{"statusCode":200,"statusMessage":"","statusTime":"2011-10-10T21:32:14.195Z"}
JAVASCRIPT
  json
end

def json_response_404
  json = <<JAVASCRIPT
{"statusCode":404,"statusMessage":"Invalid URL - Mailing list key not found.","statusTime":"2011-10-10T21:32:14.195Z"}
JAVASCRIPT
  json
end

def json_template_create
  json = <<JAVASCRIPT
{"templateKey":"33ffafac-b15e-4146-b046-14ed897c522b", "statusCode":201, "statusMessage":"Template saved", "statusTime":"2013-05-02T18:26:27.512Z"}
JAVASCRIPT
  json
end

def json_template_get
  json = <<JAVASCRIPT
{"template":{"toEmail":"{{rcpt_email}}","fromEmail":"{{sender_email}}","subject":"BOB {{{rcpt_name}}}","toName":"{{rcpt_name}}","fromName":"{{sender_name}}","returnPath":"{{return_path}}","plaintextBody":"Plain Text Body {{text_value}}","htmlBody":"<p>The test is working</p>","templateKey":"43ffafac-b15e-4146-b046-14ed897c522b","apiKey":"7215ee9c7d9dc229d2921a40e899ec5f","customHeaders":{"X-MessageBus-Test":"rBob","envelope-sender":"{{return_path}}"},"sessionKey":"{{session_key}}","creationTime":"2013-05-02T18:26:27.512Z"},"statusCode":200,"statusMessage":"","statusTime":"2013-05-02T18:34:20.590Z"}
JAVASCRIPT
  json
end

def json_templates_get
  json = <<JAVASCRIPT
{"templates":[{"templateKey":"14a47f55-8fe5-49e3-ba41-fa26cb3ca1db","modificationTime":"2013-04-12T06:53:49.000Z","size":639},{"templateKey":"43ffafac-b15e-4146-b046-14ed897c522b","modificationTime":"2013-05-02T18:26:28.000Z","size":584},{"templateKey":"99fb84a3-b4e8-4aeb-8b89-364510becd07","modificationTime":"2013-05-01T04:17:45.000Z","size":584}],"count":3,"statusCode":200,"statusMessage":"","statusTime":"2013-05-02T18:55:11.991Z"}
JAVASCRIPT
  json
end

def json_templates_email_send
  json = <<JAVASCRIPT
{"failureCount":0, "results":[{"messageId":"71690500b35b11e28c8290b8d0a751ab", "messageStatus":0, "toEmail":"bob@example.com"}], "statusCode":202, "statusMessage":"", "successCount":1, "statusTime":"2013-05-02T19:06:50.397Z"}
JAVASCRIPT
  json
end

def json_templates_email_send_empty
  json = <<JAVASCRIPT
{"failureCount":0, "results":[], "statusCode":202, "statusMessage":"", "successCount":0, "statusTime":"2013-05-02T19:06:50.397Z"}
JAVASCRIPT
  json
end

def json_webhooks
  json = <<JAVASCRIPT
{
"statusCode":200,
"statusMessage":"OK",
"statusTime":"2014-01-22T23:12:45.768Z",
"webhooks":[
    {"enabled":true,
     "eventType":"recipient.block",
     "uri":"http://webhook.messagebus.com/events/block",
     "webhookKey":"902e4a3d-24a0-470f-bbde-58f81fc04b79",
     "lastUpdated":"2014-01-22T23:31:42Z",
     "dateCreated":"2014-01-22T23:31:42Z",
     "batching":{
        "batchingEnabled":true,
        "batchTimeSeconds":30,
        "maxBatchSize":500}
    },
    {"enabled":true,
     "eventType":"message.attempt",
     "uri":"http://webhook.messagebus.com/events/attempt",
     "webhookKey":"9b4309e1-0551-4c7a-ab0b-4b69f977201f",
     "lastUpdated":"2014-01-22T23:31:35Z",
     "dateCreated":"2014-01-22T23:31:35Z",
     "batching":{
        "batchingEnabled":true,
        "batchTimeSeconds":30,
        "maxBatchSize":500
     },
     "channelKey":"DDCEFC35298644A998606CAB10F38501"
    }
]
}
JAVASCRIPT
  json
end

def json_webhook
  json = <<JAVASCRIPT
{
"statusCode":200,
"statusMessage":"OK",
"statusTime":"2014-01-22T23:12:45.768Z",
"webhook":
    {"enabled":true,
     "eventType":"recipient.complaint",
     "uri":"http://webhook.messagebus.com/messagebus/v5/recipient-complaint",
     "webhookKey":"43980222-6bef-46aa-8644-d6b7e0b8c98a",
     "lastUpdated":"2014-01-22T22:29:59Z",
     "dateCreated":"2014-01-22T21:32:17Z",
     "batching":
        {"batchingEnabled":true,
         "batchTimeSeconds":30,
         "maxBatchSize":500
        },
     "channelKey":"DDCEFC35298644A998606CAB10F38501"
    }
}
JAVASCRIPT
  json
end

def json_webhook_no_channel
  json = <<JAVASCRIPT
{
"statusCode":200,
"statusMessage":"OK",
"statusTime":"2014-01-22T23:12:45.768Z",
"webhook":
    {"enabled":true,
     "eventType":"recipient.complaint",
     "uri":"http://webhook.messagebus.com/messagebus/v5/recipient-complaint",
     "webhookKey":"43980222-6bef-46aa-8644-d6b7e0b8c98a",
     "lastUpdated":"2014-01-22T22:29:59Z",
     "dateCreated":"2014-01-22T21:32:17Z",
     "batching":
        {"batchingEnabled":true,
         "batchTimeSeconds":30,
         "maxBatchSize":500
        }
    }
}
JAVASCRIPT
  json
end

def json_webhook_create
  json = <<JAVASCRIPT
{
"statusCode":201,
"statusMessage":"Webhook created.",
"statusTime":"2014-01-24T23:35:45.083Z",
"webhookKey":"8d77789a13144923ba7b38b8ffff0f6c"
}
JAVASCRIPT
  json
end

def json_webhook_update
  json = <<JAVASCRIPT
{
"statusCode":200,
"statusMessage":"OK",
"statusTime":"2014-01-24T23:29:03.483Z"
}
JAVASCRIPT
  json
end

def json_webhook_delete
  json = <<JAVASCRIPT
{
"statusCode":200,
"statusMessage":"Webhook deleted.",
"statusTime":"2014-01-24T23:31:05.546Z"
}
JAVASCRIPT
  json
end


def json_report_request_response201
  json = <<JAVASCRIPT
{"statusCode":201,"statusMessage":"Report request received.","statusTime":"1971-01-01T00:00:00.000Z","reportKey":"e98d2f001da5678b39482efbdf5770dc","reportStatus":"created","reportQuota":50,"reportQuotaRemaining":49}
JAVASCRIPT
  json
end

def json_report_status_request_response_done200
  json = <<JAVASCRIPT
{"statusCode":200,"statusMessage":"Report has completed.","statusTime":"1971-01-01T00:00:00.000Z","reportStatus":"done"}
JAVASCRIPT
  json
end

def json_report_status_request_response_running200
  json = <<JAVASCRIPT
{"statusCode":200,"statusMessage":"Report is still running.","statusTime":"1971-01-01T00:00:00.000Z","reportStatus":"running"}
JAVASCRIPT
  json
end

def json_report_status_request_response_no_data200
  json = <<JAVASCRIPT
{"statusCode":200,"statusMessage":"Report contains no data.","statusTime":"1971-01-01T00:00:00.000Z","reportStatus":"nodata"}
JAVASCRIPT
  json
end

def json_report_request_data_bounce
  json = <<JAVASCRIPT
{"type":"bounce","channelKey":"0000000000ABCDEF0123456789ABCDEF","sessionKey":"1111111111ABCDEF0123456789ABCDEF","email":"bob@hotmail.com","bounceCode":1000,"eventTime":"1971-01-01T23:45:00.000Z","sendTime":"1971-01-01T00:00:00.000Z"}
JAVASCRIPT
  json
end

class MessagebusMailer < MessagebusActionMailerClient
  def initialize(*args)
    api_key = "098f6bcd4621d373cade4e832627b4f6"
    super(api_key)
  end
end

ActionMailer::Base.add_delivery_method :messagebus, MessagebusMailer
ActionMailer::Base.delivery_method = :messagebus

class MessageBusActionMailerTest < ActionMailer::Base
  default :from => "Mail Test <no-reply@messagebus.com>",
          :body => "This is a test",
          :subject => "Unit Test",
          :return_path => "bounce@bounce.example.com"

  def new_message(to_email, session_key, bcc = "", x_headers = {})
    headers[MessagebusSDK::MessagebusBase::HEADER_SESSION_KEY] = session_key
    x_headers.each do |key, value|
      headers[key] = value
    end

    mail(:bcc => bcc) if bcc != ""
    mail(:to => to_email)
  end
end
