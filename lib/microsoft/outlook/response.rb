module Microsoft
  module Outlook
    class Response
      attr_accessor :api_response
      attr_reader :raw_http_response
      
      #parsed_response_hash is httparty response body
      def initialize(parsed_response_hash, result=nil)
        @api_response = parsed_response_hash
        @raw_http_response = result
        self
      end

      def message_id
        api_response.dig('id')
      end

      def message_internet_id
        api_response.dig('internetMessageId')
      end

      def message_conversation_id
        api_response.dig('conversationId')
      end

      #sender and from hold same data as nested hash
      #hash with key emailAddress containing another hash with keys name, address
      def message_sender
        api_response.dig('sender')
      end

      def message_sender_email
        api_response.dig('sender', 'emailAddress', 'address')
      end

      def message_sender_name
        api_response.dig('sender', 'emailAddress', 'name')
      end

      def message_subject
        api_response.dig("subject")
      end

      def message_body
        api_response.dig('body')
      end

      def message_body_content
        api_response.dig('body', 'content')
      end

      def message_body_content_type
        api_response.dig('body', 'contentType')
      end

      def is_message_read?
        api_response.dig("isRead") 
      end

      #returns an array of nested hashes
      #returns hash with key emailAddress containing another hash with keys name, address
      def message_recipients
        api_response.dig('toRecipients')
      end

      #returns an array of Microsoft::Outlook::Response
      def self.api_find_messages_array_result(result)
        parsed_response_hash = result.parsed_response

        array_of_hash_values = parsed_response_hash.dig('value')
        array_of_hash_values.map do |hash_value|
          new(hash_value, result)
        end
      end

    end 
  end
end

