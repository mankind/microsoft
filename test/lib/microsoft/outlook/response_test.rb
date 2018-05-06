require 'test_helper'

class ResponseTest <  MiniTest::Test
  def setup
    id = mail_id_to_reply
    stub_request(:get, "https://graph.microsoft.com/v1.0/me/messages/#{id}").
      with(:headers => client.headers).
      to_return(:status => 200, body: fetch_single_mail_response_json, headers:  {"Content-Type"=> "application/json"} )

    @result = client.get_single_mail(id)
    @result
  end

  def test_response_class_is_correct
    assert_equal Microsoft::Outlook::Response, @result.class
  end


  def test_mail_id_is_correct
    assert_equal mail_id_to_reply, @result.message_id
  end

  def test_mail_sender_details
    sender = {"emailAddress"=>{"name"=>"Wizebee Wizebee", "address"=>"wiz@outlook.com"}}

    assert_equal sender, @result.message_sender
  end

  def test_mail_sender_email
    assert_equal 'wiz@outlook.com', @result.message_sender_email
  end

  def test_recipient_details
    recipients = [{"emailAddress"=>{"name"=>"bill4@yahoo.com", "address"=>"bill4@yahoo.com"}}]

    assert_equal recipients, @result.message_recipients
  end

  def test_is_message_read
    assert_equal true, @result.is_message_read?
  end

end

