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

require 'messagebus_base'

class MessagebusWebhookClient < MessagebusSDK::MessagebusBase

  EVENT_TYPE_MESSAGE_ATTEMPT = 'message.attempt'
  EVENT_TYPE_MESSAGE_ACCEPT = 'message.accept'
  EVENT_TYPE_MESSAGE_BOUNCE = 'message.bounce'
  EVENT_TYPE_MESSAGE_DEFERRAL = 'message.deferral'
  EVENT_TYPE_MESSAGE_OPEN = 'message.open'
  EVENT_TYPE_LINK_CLICK = 'link.click'
  EVENT_TYPE_RECIPIENT_UNSUBSCRIBE = 'recipient.unsubscribe'
  EVENT_TYPE_RECIPIENT_COMPLAINT = 'recipient.complaint'
  EVENT_TYPE_RECIPIENT_BLOCK = 'recipient.block'

  def initialize(api_key, api_endpoint = DEFAULT_API_ENDPOINT)
    super(api_key, api_endpoint)
    @rest_endpoints = define_rest_endpoints
  end

  def webhooks
    path = "#{@rest_endpoints[:webhooks]}"
    make_api_request(path, HTTP_GET)
  end

  def webhook(webhook_key)
    path =  replace_webhook_key("#{@rest_endpoints[:webhook]}", webhook_key)
    make_api_request(path, HTTP_GET)
  end

  def create(params)
    path = "#{@rest_endpoints[:webhooks]}"
    make_api_request(path, HTTP_POST, params.to_json)
  end

  def update(webhook_key, params)
    path =  replace_webhook_key("#{@rest_endpoints[:webhook]}", webhook_key)
    make_api_request(path, HTTP_PUT, params.to_json)
  end

  def delete(webhook_key)
    path =  replace_webhook_key("#{@rest_endpoints[:webhook]}", webhook_key)
    make_api_request(path, HTTP_DELETE)
  end

  private

  def define_rest_endpoints
    {
      :webhooks => "/v5/webhooks",
      :webhook => "/v5/webhook/%WEBHOOK_KEY%"
    }
  end
end

