module Microsoft
  # Custom error class for rescuing from all Microsoft errors
  class Error <  StandardError 
    attr_reader :code, :error_hash

    # Raised when Microsoft returns a string code
    ClientError = Class.new(self)

    # Microsoft raises this when it is unable to read JSON request payload
    # that means the json is of the wrong format eg when reply json is not
    # in the form "{comment: 'my reply'}"
    BadRequest = Class.new(ClientError)

    # When access_token is invalid, Microsoft raises CompactToken validation failed
    Unauthorized = Class.new(ClientError)

    # Raised when Microsoft returns the HTTP status code 403
    Forbidden = Class.new(ClientError)

    # Raised when Microsoft returns the HTTP status code 404
    NotFound = Class.new(ClientError)

    # Raised when Microsoft returns the HTTP status code 406
    NotAcceptable = Class.new(ClientError)

    # Raised when Microsoft returns the HTTP status code 413
    RequestEntityTooLarge = Class.new(ClientError)

    # Raised when Microsoft returns the HTTP status code 422
    UnprocessableEntity = Class.new(ClientError)

    # Raised when  Microsoft returns the HTTP status code 429
    TooManyRequests = Class.new(ClientError)

    # Raised when  Microsoft returns a 5xx HTTP status code
    ServerError = Class.new(self)

    # Raised when  Microsoft returns the HTTP status code 500
    InternalServerError = Class.new(ServerError)
    
    ERRORS = {
      400 => Microsoft::Error::BadRequest,
      401 => Microsoft::Error::Unauthorized,
      403 => Microsoft::Error::Forbidden,
      404 => Microsoft::Error::NotFound,
      406 => Microsoft::Error::NotAcceptable,
      413 => Microsoft::Error::RequestEntityTooLarge,
      422 => Microsoft::Error::UnprocessableEntity,
      429 => Microsoft::Error::TooManyRequests,
      500 => Microsoft::Error::InternalServerError,
    }.freeze

    #Initializes a new Error object
    #
    # @param message [Exception, String]
    # @param code [Integer]
    # @return [Microsoft::Error]
    def initialize(msg = '', code = nil)
      message = super(msg)
      @code = code 
      if !code.nil?
        @error_hash = {:code => code, :message => message}
      else
        #for all other errors not defined in http status code constant in Microsoft::Error::ERRORS above 
        message
      end
    end

    # Create a new error from an HTTP response
    #
    # @param result [Object] is the HTTParty::Response object
    # @return [Microsoft::Error]
    def self.error_from_response(result)
      if !result.nil?
        http_status_code = result.code
        response = result.parsed_response
        microsoft_error_code = response.dig('error', 'code')
        microsoft_error_message = response.dig('error', 'message')
        message =  microsoft_error_code.to_s + ': ' + microsoft_error_message
        new(message, http_status_code)
      end
    end
  end
end

