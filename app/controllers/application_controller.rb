class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # signup params
    %w{ first_name last_name phone email_confirmation }.each do |param|
        devise_parameter_sanitizer.for(:sign_up) << param.to_sym
    end
  end
end
