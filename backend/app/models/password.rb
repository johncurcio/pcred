require "base64"
require 'twilio-ruby'

class Password < ActiveRecord::Base

  validates :website, uniqueness: { scope: :user_id }
  belongs_to :user

  ADDRESSES = [
    '%s@message.alltel.com',
    '%s@messaging.sprintpcs.com',
    '%s@mobile.celloneusa.com',
    '%s@msg.telus.com',
    '%s@paging.acswireless.com',
    '%s@pcs.rogers.com',
    '%s@qwestmp.com',
    '%s@sms.mycricket.com',
    '%s@sms.ntwls.net',
    '%s@tmomail.net',
    '%s@txt.att.net',
    '%s@txt.windmobile.ca',
    '%s@vtext.com',
    '%s@text.republicwireless.com',
    '%s@msg.fi.google.com'
  ]
  
  KEY_CHARS = [*("a".."z"),*("A".."Z"),*("0".."9")]



#    ADDRESSES.map{|t| t.sub("%s", phone_number)}.each do |email|
#      str = 'echo "' + message + '" | mail -s "Subject" -aFrom:Pcred\<pcred8092@gmail.com\> ' + email
#      system(str)
#    end

#    system('curl http://textbelt.com/text -d number=' + phone_number + ' -d "message=' + message + '"')
    

  def send_password_text
    user = self.user

    account_sid = 'AC3fec931a933718d7fa67ffad27273847' 
    auth_token = '7cc5bf9f01bd698ea07744ff416f016f' 

    key = (0...10).map { KEY_CHARS[SecureRandom.random_number(62)] }.join
    phone_number = user.phone_number.to_s
    message = "ENTER THE FOLLOWING ACCESS KEY: " + key.gsub(/[^0-9a-z]/i, '')

    # set up a client to talk to the Twilio REST API 
    @client = Twilio::REST::Client.new account_sid, auth_token 
     
    @client.account.messages.create(
      from: "+18442948902",
      to: ("+1"+phone_number),
      body: message
    ) 
    return key
  end

  def send_conceal(key,user_pass)
    cipher = OpenSSL::Cipher::AES256.new(:CBC) 
    cipher.encrypt

    iv = cipher.random_iv
    real_key = Digest::SHA256.digest(key)

    cipher.iv = iv
    cipher.key = real_key

    cipher_text = cipher.update(self.reveal(user_pass)) + cipher.final
    cipher_text_b64 = Base64.encode64(cipher_text)

    iv_b64 = Base64.encode64(iv)

    puts "Key: " + key

    return {password_cipher: cipher_text_b64, iv: iv_b64}
  end



  def conceal(password, user_pass)
    cipher = OpenSSL::Cipher::AES256.new(:CBC) 
    cipher.encrypt

    iv = cipher.random_iv
    key = Digest::SHA256.digest(user_pass)

    cipher.iv = iv
    cipher.key = key

    cipher_text = cipher.update(password) + cipher.final

    self[:password_cipher] = Base64.encode64(cipher_text)
    self[:iv] = Base64.encode64(iv)
  end

  def reveal(user_pass)
    cipher = OpenSSL::Cipher::AES256.new(:CBC) 
    cipher.decrypt
    
    iv = Base64.decode64(self.iv)
    key = Digest::SHA256.digest(user_pass)

    cipher.iv = iv
    cipher.key = key

    plain_text = cipher.update(Base64.decode64(self.password_cipher)) + cipher.final

    return plain_text
  end

  def convert(old_user_pass, user_pass)
    cipher = OpenSSL::Cipher::AES256.new(:CBC) 
    cipher.decrypt
    iv = Base64.decode64(self.iv)
    key = Digest::SHA256.digest(old_user_pass)
    cipher.iv = iv
    cipher.key = key
    password = cipher.update(Base64.decode64(self.password_cipher)) + cipher.final
    
    cipher = OpenSSL::Cipher::AES256.new(:CBC) 
    cipher.encrypt
    iv = cipher.random_iv
    key = Digest::SHA256.digest(user_pass)
    cipher.iv = iv
    cipher.key = key
    cipher_text = cipher.update(password) + cipher.final

    self[:password_cipher] = Base64.encode64(cipher_text)
    self[:iv] = Base64.encode64(iv)
  end    

end
