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

class MessagebusTemplateClient < MessagebusSDK::MessagebusBase
  DEFAULT_TEMPLATE_ENDPOINT = 'https://templates.messagebus.com'

  def initialize(api_key, api_endpoint = DEFAULT_TEMPLATE_ENDPOINT)
    super(api_key, api_endpoint)
    @rest_endpoints = define_rest_endpoints
  end

  def template_version
    make_api_request(@rest_endpoints[:template_version])
  end

  def create_template(params)
    path = @rest_endpoints[:templates]
    template_params = base_template_params.merge!(params)
    make_api_request(path, HTTP_POST, template_params.to_json)
  end

  def get_template(template_key)
    path = replace_token_with_key(@rest_endpoints[:template], "%TEMPLATE_KEY%", template_key)
    make_api_request(path)
  end

  def send_messages(template_key, params)
    if params.length > MessagebusSDK::MessagebusBase::MAX_TEMPLATE_MESSAGES
      raise MessagebusSDK::TemplateError.new("Max number of template messages per send exceeded #{MessagebusSDK::MessagebusBase::MAX_TEMPLATE_MESSAGES}")
    end

    path = @rest_endpoints[:templates_send]
    json = {:templateKey => template_key, :messages => params}.to_json
    make_api_request(path, HTTP_POST, json)
  end

  def templates
    path = "#{@rest_endpoints[:templates]}"
    make_api_request(path)
  end

  private
  def define_rest_endpoints
    {
      :template_version => "/v5/templates/version",
      :template => "/v5/template/%TEMPLATE_KEY%",
      :templates => "/v5/templates",
      :templates_send => "/v5/templates/email/send"
    }
  end

  def base_template_params
    {:toEmail => '',
     :fromEmail => '',
     :subject => '',
     :toName => '',
     :fromName => '',
     :returnPath => '',
     :plaintextBody => '',
     :htmlBody => '',
     :sessionKey => DEFAULT,
     :options => {},
     :customHeaders => {} }
  end
end
