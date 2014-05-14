class AdminController < ApplicationController
  before_filter :authenticate_contestant!
  before_filter :admins_only!

  before_filter :get_admin

  def index
    @photos = Photo.all
  end

  def confirm_photo
    photo = Photo.find params[:id]

    photo.submission_complete = true
    photo.save

    render nothing: true and return if request.xhr?
    redirect_to admin_root_path
  end

  private 

  def admins_only!
    unless current_contestant.admin?
      redirect_to root_path
    end
  end

  def get_admin
    @admin = current_contestant
  end
end