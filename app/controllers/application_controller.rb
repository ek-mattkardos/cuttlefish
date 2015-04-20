class ApplicationController < ActionController::Base
  include Pundit
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authenticate_admin!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
   dash_path
  end

  force_ssl :if => Proc.new{ force_ssl? }

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:accept_invitation) << :name
    devise_parameter_sanitizer.for(:account_update) << :name
    devise_parameter_sanitizer.for(:sign_up) << :name
  end

  # Don't use SSL for the TrackingController and in development
  def force_ssl?
   controller_name != "tracking" && !Rails.env.development? && !Rails.configuration.disable_ssl
  end

  def pundit_user
    current_admin
  end
end
