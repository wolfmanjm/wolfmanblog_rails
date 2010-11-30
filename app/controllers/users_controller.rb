require 'digest/sha1'

class UsersController < ApplicationController

  def login
    @nonce= "01020304050607080910"
    session[:nonce]= @nonce
  end

  def attempt_login
    username= params[:login]
    logger.info "got auth token of #{params[:password]} for user #{username}"
    nonce= session[:nonce]
    user= User[:name => username]
    if user
      logger.debug "user #{username} found"
      cp = user.crypted_password
      sha1 = Digest::SHA1.hexdigest("#{cp}-#{nonce}")
      logger.info "calculated auth token #{sha1}"
      if sha1 == params[:password]
        logger.info "Login OK"
        session[:logged_in]= true
      else
        logger.info "Login failed"
        session[:logged_in]= nil
      end
    else
      logger.debug "user #{username} not found"
      session[:logged_in]= nil
    end

    redirect_to root_path
  end

  def logout
    session[:logged_in]= nil
    logger.info "logged out ok"
    redirect_to root_path
  end

end
