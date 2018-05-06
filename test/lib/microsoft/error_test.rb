require_relative '../../test_helper'

class ClientTest <  MiniTest::Test
  
  def test_error_message_is_returned
    msg = "CompactToken validation failed with reason code: 80049228."
    code = 401
    message =  code.to_s + ': ' + msg

    error = Microsoft::Error::Unauthorized.new(message, code)

    assert_equal code, error.code
    assert_equal message, error.message
  end

  def test_401_error_i_raised
    stub_request(:get, 'https://graph.microsoft.com/v1.0/me/messages').
      with(:headers => client.headers).
      to_return(:status => [401, "Forbidden"],  body: load_401_error_message_json, headers:  {"Content-Type"=> "application/json"} )

    assert_raises  Microsoft::Error::Unauthorized do
      client.fetch_mails
    end
  end

  def test_bad_request
    id = mail_id_to_reply
      
    stub_request(:post, "https://graph.microsoft.com/v1.0/me/messages/#{id}/reply").
      with(:headers => client.headers, :body => 'wrong reply format should be json').
      to_return(:status => 400, body: badrequest_error_json, headers:  {"Content-Type"=> "application/json"} )

    assert_raises  Microsoft::Error::BadRequest do
      client.reply_mail(id, 'wrong reply format should be json')
    end 
  end

  def test_bad_request
    id = mail_id_to_reply
       
    stub_request(:post, "https://graph.microsoft.com/v1.0/me/messages/#{id}/reply").
      with(:headers => client.headers, :body => 'wrong reply format should be json').
      to_return(:status => 500, body: internal_server_error_json, headers:  {"Content-Type"=> "application/json"} )

    assert_raises  Microsoft::Error::InternalServerError do
      client.reply_mail(id, 'wrong reply format should be json')
    end
  end

  def test_all_error_codes_and_exceptions
      id = mail_id_to_reply
      Microsoft::Error::ERRORS.each do |status, exception|
         stub_request(:post, "https://graph.microsoft.com/v1.0/me/messages/#{id}/reply").
           with(:headers => client.headers, :body => 'wrong reply format should be json').
           to_return(:status => status, body: internal_server_error_json, headers:  {"Content-Type"=> "application/json"} )

         assert_raises exception do
           client.reply_mail(id, 'wrong reply format should be json')
        end
      end 
  end
    
end

