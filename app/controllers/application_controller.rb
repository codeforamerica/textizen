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
  def welcome
    render "static_pages/home"
  end
  def privacy
    render "static_pages/privacy"
  end
  def about
    render "static_pages/about"
  end
end
