require 'digest/sha1'

class UsersController < ApplicationController

  def login
    @nonce= make_nonce
    session[:nonce]= @nonce
  end

  def attempt_login
    username= params[:login]
    logger.info "got auth token of #{params[:password]} for user #{username}"
    nonce= session[:nonce]
    session[:nonce]= nil
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

  private

  def make_nonce
    t = Time.now.to_i
    hashed = [t, Wolfmanblog::Application.config.secret_token]
    digest = ::Digest::SHA1.hexdigest(hashed.join(":"))
    ActiveSupport::Base64.encode64("#{t}:#{digest}").gsub("\n", '')
  end

end
