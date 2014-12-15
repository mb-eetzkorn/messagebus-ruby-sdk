![MB icon](http://developer.messagebus.com/assets/mb-logo-env@2x.png)

###Message Bus Ruby SDK

Message Bus is a cloud-based platform for easily sending email at scale and with complete insight into your messaging traffic and how recipients are responding to it. All platform functions are available via [REST API](http://www.messagebus.com/documentation) as well as the language-specific documentation, sample code, libraries, and/or compiled binaries contained in this SDK.

Samples include how to:

* Create sessions
* Send messages
* Use templates
* Check email stats

If you have questions not answered by the samples or the online documentation, please contact [support](mailto:support@messagebus.com).


####Installing the module

    gem install messagebus-sdk

    If running the examples from the project without installing the gem, you will
    need to set RUBYLIB path.

    Example: export RUBYLIB=/Users/<user_name>/workspace/messagebus-ruby-sdk/lib/messagebus-sdk

####Sending emails

    require 'messagebus-sdk/api_client'

    api_key="12345678934628542E2599F7ED712345"
    api_host="https://api.messagebus.com"

    client = MessagebusApiClient.new(api_key, api_host)

    session_key = "DEFAULT"

    messages = [
        {:toEmail => 'bobby@example.com',
         :toName => 'Bobby Flay',
         :fromEmail => 'alice@example.com',
         :fromName => 'Alice Waters',
         :returnPath => 'bounces@bounces.example.com',
         :subject => 'Sample Message with HTML body.',
         :customHeaders => {"x-messagebus-sdk"=>"ruby-sdk"},
         :plaintextBody => 'This is the plain text body.',
         :htmlBody => 'This is the <b>HTML</b>body.',
         :sessionKey => session_key},
        {:toEmail => 'jamie@example.com',
         :toName => 'Jamie Lauren',
         :fromEmail => 'alice@example.com',
         :fromName => 'Alice Waters',
         :returnPath => 'bounces@bounces.example.com',
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

####Sending emails with ActionMailer

    require 'action_mailer'
    require 'messagebus-sdk/actionmailer_client'

    class MessagebusMailer < MessagebusActionMailerClient
      def initialize(*args)
        api_key = "12345678934628542E2599F7ED712345"
        api_endpoint = "https://api.messagebus.com"
        super(api_key, api_endpoint)
      end
    end

    ActionMailer::Base.add_delivery_method :messagebus, MessagebusMailer
    ActionMailer::Base.delivery_method = :messagebus

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


#### License


    Copyright (c) 2014 Message Bus

    Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance
    with the License. You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software distributed under the License is
    distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and limitations under the License
