class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # signup params
    %w{ first_name last_name public_name phone }.each do |param|
        devise_parameter_sanitizer.for(:sign_up) << param.to_sym
    end
  end

  def after_sign_in_path_for(resource)
    contestant_index_path
  end

  # redirect back to referrer or homepage
  def redirect_back_or_home
    if !request.env["HTTP_REFERER"].blank? and request.env["HTTP_REFERER"] != request.env["REQUEST_URI"]
      redirect_to :back
    else
      redirect_to root_path
    end
  end

  # redirects back or to home if the contest is no longer open
  def only_contest_open!
    unless ContestRules.contest_open?
      flash[:alert] = "The submission period is now closed. You may not add or edit photo entries."
      redirect_back_or_home
    end
  end
end