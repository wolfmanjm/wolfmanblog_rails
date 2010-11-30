require 'digest/sha1'
class User < Sequel::Model
  def self.new_password(user, ctpw)
    u= filter(:name => user).first
    if u
      cpw= Digest::SHA1.hexdigest(ctpw)
      u.update(:crypted_password => cpw)
    else
      logger.error("User #{user} not found")
    end
  end
end
