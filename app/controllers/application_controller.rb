class ApplicationController < ActionController::Base
  protect_from_forgery
   def index
    if user_signed_in?
      redirect_to :polls
    else
      redirect_to :welcome #redirect_to new_user_session_path #"/welcome"
    end
    #render welcome page by default
  end
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to new_user_session_url, :alert => exception.message
  end
end
