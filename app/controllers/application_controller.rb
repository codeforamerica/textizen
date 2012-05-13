class ApplicationController < ActionController::Base
  protect_from_forgery
   def index
    if user_signed_in?
      redirect_to :polls
#    elsif admin_signed_in?
#      redirect_to "/admin"
    else
      redirect_to new_user_session_path #"/welcome"
    end
    #render welcome page by default
  end
end
