class ApplicationController < ActionController::Base
  protect_from_forgery

  def ensure_authenticated
    unless session[:logged_in]
      logger.warn "attempt to access priv page: #{request.fullpath}"
      render :text => "not authorized", :status => 401
    end
  end

  class NotFound < Exception
  end
  class ParseError < Exception
  end

end
