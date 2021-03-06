class AccessLog < ActiveRecord::Base

after_create :messagify_and_sign

KEY = "AHLKJAHSIUHASIDNALKJSDHASKJHDKJASSHLDKJHASKJHDKJASD"

WORDMOD = {"create" => ["attempted to create", "succeeded in creating", "failed to create"],
            "login" => ["attempted to log in", "succeeded in logging in", "failed to log in"],
            "get" => ["attempted to retrieve", "succeeded in retrieving", "failed to retrieve"],
            "get_list" => ["attempted to retrieve a list of", "succeeded in retrieving a list of", "failed to retrieve a list of"],
            "validate_phone" => ["attempted to validate the phone of", "validated the phone of", "failed to validate the phone of"],
            "update" => ["attempted to update", "succeeded in updating", "failed to update"],
            "destroy" => ["attempted to destroy", "succeeded in destroying", "failed to destroy"],
            "recover" => ["attempted to recover password", "succeeded in recovering password", "failed to recover password"]
          }

  def AccessLog.attempt(user, access_class, action, active_on)
    AccessLog.create({user_id: (user.nil? ? nil : user.id),
                          access_class: access_class,
                          action: action,
                          active_on_id: (active_on.nil? ? nil : active_on.id),
                          message: WORDMOD[action][0]})
  end

  def AccessLog.success(user, access_class, action, active_on)
    AccessLog.create({user_id: (user.nil? ? nil : user.id),
                          access_class: access_class,
                          action: action,
                          active_on_id: (active_on.nil? ? nil : active_on.id),
                          message: WORDMOD[action][1]})
  end

  def AccessLog.failure(user, access_class, action, active_on)
    AccessLog.create({user_id: (user.nil? ? nil : user.id),
                          access_class: access_class,
                          action: action,
                          active_on_id: (active_on.nil? ? nil : active_on.id),
                          message: WORDMOD[action][2]})
  end

  def messagify_and_sign
    ui = self.user_id.to_s
    mess = self.message.to_s
    ac = self.access_class.to_s
    aoi = self.active_on_id.to_s
    ca = self.created_at.to_s
    
    self.message = self.user_id.nil? ? "Someone " : "User #{ui} "
    self.message = self.message + "#{mess} #{ac}"
    self.message = self.message + (self.user_id.nil? ? " at #{ca}." : " #{aoi} at #{ca}.")
    
    data = ui + self.message + ac + aoi + ca
    digest = OpenSSL::Digest.new('sha256')

    self.signature = OpenSSL::HMAC.hexdigest(digest, KEY, data)

    self.save
  end

  def verify_integrity
    ui = self.user_id.to_s
    ac = self.access_class.to_s
    aoi = self.active_on_id.to_s
    ca = self.created_at.to_s

    data = ui + self.message + ac + aoi + ca
    digest = OpenSSL::Digest.new('sha256')

    return self.signature == OpenSSL::HMAC.hexdigest(digest, KEY, data)
  end

end
