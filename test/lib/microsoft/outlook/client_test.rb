require_relative '../../../test_helper'


class ClientTest <  MiniTest::Test

  def test_httparty_included
    assert_includes Microsoft::Outlook::Client, HTTParty
  end

  def test_contains_api_base_uri
    assert_equal "https://graph.microsoft.com", Microsoft::Outlook::Client.base_uri
  end

  def test_access_token_is_correct
    assert_equal "EwA4A8", client.access_token
  end

  def test_credentials_are_correct
    credentials = {
      consumer_key: "20ad71",
      consumer_secret: "ekgwSI",
      access_token: "EwA4A8"
    }

    assert_equal credentials, client.credentials
  end

  def test_fetch_mails
   stub_request(:get, 'https://graph.microsoft.com/v1.0/me/messages').
      with(:headers => client.headers).
      to_return(:status => 200, body: fetch_mails_json, headers:  {"Content-Type"=> "application/json"} )

   result = client.fetch_mails
   assert_equal HTTParty::Response, result.first.raw_http_response.class
   assert_equal Array, result.first.raw_http_response.parsed_response['value'].class
   assert_equal "should return string", result.first.raw_http_response.parsed_response['value'].first['subject']
   assert_equal [{"emailAddress"=>{"name"=>"bill4@yahoo.com", "address"=>"bill4@yahoo.com"}}], result.first.raw_http_response.parsed_response['value'].first['toRecipients']

  end

  def test_create_draft
    stub_request(:post, 'https://graph.microsoft.com/v1.0/me/messages').
      with(:headers => client.headers, :body => generate_message).
      to_return(:status => 200, body: draft_response_json, headers:  {"Content-Type"=> "application/json"} )

    result = client.create_draft(generate_message)
    
    assert_equal Hash, result.raw_http_response.parsed_response.class
    assert_equal [{"emailAddress"=>{"name"=>"bill4@yahoo.com", "address"=>"bill4@yahoo.com"}}], result.raw_http_response.parsed_response['toRecipients']
    assert_equal draft_response_id, result.raw_http_response.parsed_response['id']
    assert_equal true, result.raw_http_response.parsed_response['isDraft']
  end

  def test_fetch_single_mail
    id = mail_id_to_reply
    stub_request(:get, "https://graph.microsoft.com/v1.0/me/messages/#{id}").
      with(:headers => client.headers).
      to_return(:status => 200, body: fetch_single_mail_response_json, headers:  {"Content-Type"=> "application/json"} )

    result = client.get_single_mail(id)
    
    assert_equal Hash, result.raw_http_response.parsed_response.class
    assert_equal [{"emailAddress"=>{"name"=>"bill4@yahoo.com", "address"=>"bill4@yahoo.com"}}], result.raw_http_response.parsed_response['toRecipients']
    assert_equal mail_id_to_reply, result.raw_http_response.parsed_response['id']
    assert_equal false, result.raw_http_response.parsed_response['isDraft']
  end

  def test_send_email
    stub_request(:post, 'https://graph.microsoft.com/v1.0/me/sendMail').
      with(:headers => client.headers, :body => generate_message).
      to_return(:status => 202, headers:  {"Content-Type"=> "application/json"} )

    result = client.send_email(generate_message)

    assert_equal HTTParty::Response, result.raw_http_response.class
    assert_equal 202, result.raw_http_response.code
    assert_nil result.raw_http_response.parsed_response
    assert_equal '', result.raw_http_response.body
    assert_equal  Net::HTTPAccepted, result.raw_http_response.response.class
  end
 
  def test_reply_to_email
    id = mail_id_to_reply
    stub_request(:post, "https://graph.microsoft.com/v1.0/me/messages/#{id}/reply").
      with(:headers => client.headers, :body => reply_to_email_text).
      to_return(:status => 202, headers:  {"Content-Type"=> "application/json"} )

    result = client.reply_mail(id, reply_to_email_text)

    assert_equal HTTParty::Response, result.raw_http_response.class
    assert_equal 202, result.raw_http_response.code
    assert_nil result.raw_http_response.parsed_response
    assert_equal '', result.raw_http_response.body
    assert_equal  Net::HTTPAccepted, result.raw_http_response.response.class
  end

end
