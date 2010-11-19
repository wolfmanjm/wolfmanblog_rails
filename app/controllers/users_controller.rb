class UsersController < ApplicationController
  before_filter :authenticate

  def login
    logger.info "logged in ok"
    redirect_to root_path
  end

  def logout
    session[:logout_requested] = true
    session[:logged_in]= nil
    logger.info "logged out ok"
    redirect_to root_path
  end

  private

  def authenticate
    result = authenticate_or_request_with_http_digest do |username|
      if session[:logout_requested]
        session[:logout_requested] = nil   # reset flag
        false
      else
        logger.debug "looking up user #{username}"
        user= User[:name => username]
        if user
          logger.debug "user #{username} found"
          user.crypted_password
        else
          logger.debug "user #{username} not found"
          false
        end
      end
    end

    if result == true
      session[:logged_in]= true
    else
      session[:logged_in]= nil
    end

  end

end
