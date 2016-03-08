class ContestsController < ApplicationController
  before_action :admins_only!

  def new
    @contest = Contest.new
  end

  def create
    @contest = Contest.new contest_params

    if @contest.save
      redirect_to admin_root_path, alert: "Created new contest"
    else
      flash[:error] = "Error creating contest"
      render :new
    end
  end

  private

  def contest_params
    return {} unless params[:contest]
    params[:contest].permit!
  end
end
