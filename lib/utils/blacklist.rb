# handles the redis backed blacklist
module Blacklist
  def add_to_blacklist(req)
    ip= req.ip.to_s
    logger.info "adding #{ip} to blacklist"
    if $redis
      $redis.set ip, "H"
    end
  end

  module_function :add_to_blacklist

end

