class ApplicationController < ActionController::Base
    helper_method :user_signed_in?, :current_user
  
    def user_signed_in?
      !current_user.nil?
    end
  
    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    rescue ActiveRecord::RecordNotFound
      nil
    end
  end
  