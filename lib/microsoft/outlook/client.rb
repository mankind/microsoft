module Microsoft
  module Outlook
    class Client
      include HTTParty
      base_uri "https://graph.microsoft.com"
      default_timeout 5   #times out after 5 seconds

      attr_accessor :access_token, :refresh_token, :client_id, :client_secret
      
      def initialize(options = {})
        options.each do |key, value|
          instance_variable_set("@#{key}", value)
        end
        yield(self) if block_given?
      end

      def headers
        {
          'Authorization' =>  "Bearer #{access_token}",
          'Content-Type' => 'application/json'
        }
      end

      def credentials
        {
          consumer_key: client_id,
          consumer_secret: client_secret,
          access_token: access_token
        }
      end

      def refresh_access_token
        host = 'https://login.microsoftonline.com/common/oauth2/v2.0/token'
        options = {
          body: {
            client_id: client_id,
            client_secret: client_secret,
            refresh_token: refresh_token,
            grant_type: 'refresh_token'
          },
          headers: {
            'Content-Type' => 'application/x-www-form-urlencoded'
          }
        }
        self.class.post(host, options)
      end

      def fetch_mails
        result = self.class.get(api_version("messages"), headers: headers)

        fail_or_return_response_body(result, true)
        
      end

      def get_single_mail(mail_id)
        result = self.class.get(api_version("messages/#{mail_id}"), headers: headers)
        fail_or_return_response_body(result)
      end

      def reply_mail(mail_id, email_message)
        result = self.class.post(
                  api_version("messages/#{mail_id}/reply"),
                  :body => email_message,
                  :headers => headers
                )
        fail_or_return_response_body(result)
      end

      def create_draft(email_message)
        result = self.class.post(
          api_version("messages"), 
           :body => email_message,
           :headers => headers
         )
        fail_or_return_response_body(result)
      end

      def send_email(email_message)
        result = self.class.post(
          api_version("sendMail"), 
          :body => email_message,
          :headers => headers
        ) 
        fail_or_return_response_body(result)      
      end

      private
      def api_version(uri)
        "/v1.0/me/#{uri}"
      end

      def response_object(result, array_response)
        parsed_response_hash = result.parsed_response
        if array_response
          Microsoft::Outlook::Response.api_find_messages_array_result(result)
        else
          Microsoft::Outlook::Response.new(parsed_response_hash, result)
        end
      end

      def fail_or_return_response_body(result, array_response = false)
        error = error(result)
        raise(error) if error
        response_object(result, array_response) 
      end

      def error(result)
        code = result.code 
        klass = Microsoft::Error::ERRORS[code] 
        
        if !klass.nil?
          klass.error_from_response(result)

        elsif result.class != HTTParty::Response
       
          #Raises errors not defined in Microsoft::Error::ERRORS
          Microsoft::Error.new(message = result)
        end
      end

    end
  end
end

