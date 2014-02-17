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

require 'api_client'

class MessagebusActionMailerClient < MessagebusApiClient

  #used by ActionMailer
  def deliver(message)
    deliver!(message)
  end

  def deliver!(message)
    #minimum required headers
    if message.to.first.nil? ||message.subject.nil? || message.from.first.nil?  || message.return_path.nil? then
      raise "Messagebus API error=Missing required header: :toEmail => #{message.to.first} :subject => #{message.subject} :fromEmail => #{message.from.first}"
    end

    message_from_email = from_email_with_name(message.header[:from].to_s)

    from_name = ""
    from_email = message.from.first
    if !message_from_email.nil?
      from_name = message_from_email[1]
    end

    if !well_formed_address?(from_email)
      raise "Messagebus API error=From Address is invalid :toEmail => #{message.to.first} :subject => #{message.subject} :fromEmail => #{message.from.first}"
    end

    custom_headers = {}

    custom_headers["bcc"] = message.bcc[0] if !message.bcc.nil?

    session_key = DEFAULT
    message.header.fields.each do |f|
      if f.name == HEADER_SESSION_KEY
        session_key = f.value
      else
        if f.name =~ /x-.*/i
          custom_headers[f.name] = f.value
        end
      end
    end

    msg = {
      :toEmail => message.to.first,
      :toName => "",
      :subject => message.subject,
      :fromEmail => from_email,
      :fromName => from_name,
      :returnPath => message.return_path,
      :sessionKey => session_key,
      :customHeaders => custom_headers
    }

    msg[:plaintextBody] = ( message.body ) ? "#{message.body}" : "No plaintext version was supplied."

    if message.multipart?
      msg[:plaintextBody] = (message.text_part) ? message.text_part.body.to_s : "No plaintext version was supplied."
      msg[:htmlBody] = message.html_part.body.to_s if message.html_part
    end

    begin
      send_messages([msg])
    rescue => message_bus_api_error
      raise "Messagebus API error=#{message_bus_api_error}, message=#{msg.inspect}"
    end

  end

  private
  def from_email_with_name(address)
    address.match(/^(.*)\s<(.*?)>/)
  end
end

