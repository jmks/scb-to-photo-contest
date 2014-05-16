class AdminController < ApplicationController
  before_filter :authenticate_contestant!
  before_filter :admins_only!

  before_filter :get_admin_photos_judges_comments

  def index
    @judge = Judge.new params[:judge]
  end

  def confirm_photo
    photo = Photo.find params[:id]

    photo.submission_complete = true
    photo.save

    render nothing: true and return if request.xhr?
    redirect_to admin_root_path
  end

  def add_judge
    @judge = Judge.new judge_params
    @judge.password = pass = Devise.friendly_token.first(8)

    if @judge.save
      flash[:notice] = "Judge #{@judge.full_name} Successfully Added"
      
      ContactMailer.judge_init(@judge.email, @judge.first_name, pass).deliver

      redirect_to admin_root_path
    else
      flash[:alert] = "There was an error adding new judge"
      render :index
    end
  end

  private 

  def admins_only!
    unless current_contestant.admin?
      redirect_to root_path
    end
  end

  def get_admin_photos_judges_comments
    @admin = current_contestant
    @photos = Photo.all
    @judges = Judge.all
    @flagged_comments = Comment.where(reported: true)
  end

  def judge_params
    params.require(:judge).permit(:first_name, :last_name, :email)
  end
end