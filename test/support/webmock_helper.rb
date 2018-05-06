
  def client
    Microsoft::Outlook::Client.new do |config|
      config.client_id = "20ad71"
      config.client_secret = "ekgwSI"
      config.access_token =  "EwA4A8"
      config.refresh_token = "MCdKMj"
    end
  end

  def load_401_error_message_json
    File.read(File.expand_path('../../fixtures/error_401.json', __FILE__))
  end

  def badrequest_error_json
    File.read(File.expand_path('../../fixtures/badrequest_error.json', __FILE__))
  end

  def internal_server_error_json
    File.read(File.expand_path('../../fixtures/internal_server_error.json', __FILE__))
  end

  def fetch_mails_json
    File.read(File.expand_path('../../fixtures/fetch_mails.json', __FILE__))
  end

  def fetch_single_mail_response_json
    File.read(File.expand_path('../../fixtures/fetch_single_mail_response.json', __FILE__))
  end

  def mail_id_to_reply
    "AQMkADAwATNiZmYAZC0wYTc1LTgyOTYtMDACLTAwCgBGAAADT9b42TGiC0aVdJhhKHRI1AcA2n4YwmoHsUCXM6oi9L9nUQAAAgEJAAAA2n4YwmoHsUCXM6oi9L9nUQAAADgHSRQAAAA="
  end

  def draft_response_id
    "AQMkADAwATNiZmYAZC0wYTc1LTgyOTYtMDACLTAwCgBGAAADT9b42TGiC0aVdJhhKHRI1AcA2n4YwmoHsUCXM6oi9L9nUQAAAgEPAAAA2n4YwmoHsUCXM6oi9L9nUQAAAHzQ0hkAAAA="
  end

  def draft_response_json
    File.read(File.expand_path('../../fixtures/draft_response.json', __FILE__))
  end

  def generate_message
    subject = 'should return string'
    content_type = 'text/html; charset=UTF-8'
    body = '<ul><li>send</li><li>via</li><li>console</li>'
    to   = 'bill4@yahoo.com'
    email_message = "{
        Message: {
           Subject: '#{subject}',
           Body: {ContentType: '#{content_type}',  Content: '#{body}' },
           ToRecipients: [
                {EmailAddress: { Address: '#{to}' }}
            ]
        },
        SaveToSentItems: true   
     }"
  end
  
  def reply_to_email_text
    "{
      comment: 'move it'
    }"

  end



  

