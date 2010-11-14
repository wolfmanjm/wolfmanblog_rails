class ApplicationController < ActionController::Base
  protect_from_forgery

  def ensure_authenticated
    unless session[:logged_in]
      logger.warn "attempt to access priv page: #{request.inspect}"
      flash[:error]= "not authorized"
      redirect_to root_path
    end
  end

  class NotFound < Exception
  end
  class ParseError < Exception
  end

end
