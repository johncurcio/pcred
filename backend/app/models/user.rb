require "base64"

class User < ActiveRecord::Base
  before_save do
    self.email = email.downcase
    self.phone_number = phone_number.gsub(/([\(\) \-])/, "")
  end

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\Z/i
  VALID_PASSWORD_REGEX = /\A([A-Za-z0-9\.\-\#\$\%\&\!\@])+\Z/i
  VALID_PHONE_REGEX = /\A([0-9])+\Z/i

  validates :first_name, presence: true, length: { minimum: 2, maximum: 20 }
  validates :last_name, presence: true, length: { minimum: 2, maximum: 30 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :phone_number, presence: true, length: { is: 10 },
                    format: { with: VALID_PHONE_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 10, maximum: 100 },
                    format: { with: VALID_PASSWORD_REGEX }, on: :create
  validate :check_password, on: :create

  has_secure_password

  has_many :passwords, dependent: :destroy

  validates :password_cipher, presence: true
  validates :iv, presence: true

  def check_password
    errors.add(:password, "must be the same as pass conf") unless password == password_confirmation
  end

  def token_check
    if self.token_expires < Time.now
      self.update(token: self.token_gen, token_expires: (Time.now + 24*3600*7).to_time) 
    end
    return self.token
  end

  def token_gen
    opts = [*("0".."9"),*("a".."z"),*("A".."Z")]
    str = ""
    100.times{ str << opts.sample }
    return str
  end

  def basic_info
    return {id: self.id,
            first_name: self.first_name,
            last_name: self.last_name,
            email: self.email}
  end

  def with_token
    return {id: self.id,
            first_name: self.first_name,
            last_name: self.last_name,
            email: self.email,
            token: self.token}
  end

  def on_login
    return {id: self.id,
            first_name: self.first_name,
            last_name: self.last_name,
            email: self.email,
            token: self.token,
            passwords: self.passwords.map{|password| password.website}
            }
  end

  def password_swap(old_password, new_password)
    passwords = self.passwords
    passwords.each do |pass|
      pass.convert(old_password, new_password)
      pass.save
    end
  end



  def User.password_auth(a1, a2, a3, pass)
    cipher = OpenSSL::Cipher::AES256.new(:CBC) 
    cipher.encrypt

    iv = cipher.random_iv
    key = Digest::SHA256.digest(a1 + a2 + a3)

    cipher.iv = iv
    cipher.key = key

    cipher_text = cipher.update(pass) + cipher.final
    cipher_text_b64 = Base64.encode64(cipher_text)

    iv_b64 = Base64.encode64(iv)

    return {password_cipher: cipher_text_b64, iv: iv_b64}
  end


  def recover_password(a1, a2, a3)
    cipher = OpenSSL::Cipher::AES256.new(:CBC) 
    cipher.decrypt
    
    iv = Base64.decode64(self.iv)
    key = Digest::SHA256.digest(a1 + a2 + a3)

    cipher.iv = iv
    cipher.key = key

    plain_text = cipher.update(Base64.decode64(self.password_cipher)) + cipher.final

    return plain_text
  end

end
