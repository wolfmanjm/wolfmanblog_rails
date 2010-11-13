class ApplicationController < ActionController::Base
  protect_from_forgery

  def ensure_authenticated
    unless session[:logged_in]
      flash[:error]= "not authorized"
      redirect_to root_path
    end
  end

  class NotFound < Exception
  end

end
