class ApplicationController < ActionController::Base
  include ActionView::Helpers::NumberHelper
  
  before_action :authenticate_user!
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_locale

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
    if self.kind_of? ActiveAdmin::BaseController
      I18n.locale = :en
    end
  end

  def default_url_options(options={})
    logger.debug "default_url_options is passed options: #{options.inspect}\n"
    { :locale => I18n.locale }
  end

  def authenticate_admin_user!
    authenticate_user! 
    unless current_user.admin?
      flash[:alert] = "This area is restricted to administrators only."
      redirect_to root_path 
    end
  end
   
  def current_admin_user
    return nil if user_signed_in? && !current_user.admin?
    current_user
  end

  def current_day
    Time.current.day
  end

  def this_month
    Time.current.month
  end

  def this_year
    Time.current.year
  end
end
