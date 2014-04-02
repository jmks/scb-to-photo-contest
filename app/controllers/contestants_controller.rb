class ContestantsController < ApplicationController
  before_filter :authenticate_contestant!

  def index
    @contestant       = current_contestant
    @favourites       = Photo.find(@contestant.voted_photo_ids || [])
    votes             = Vote.where(_id: request.remote_ip).first
    @votes_left_today = ContestRules::VOTES_PER_DAY_PER_IP - (votes ? votes.votes_today : 0)

    # can be removed
    if session[:invalid_photo_order_numbers]
      @invalid_photo_order_numbers = session[:invalid_photo_order_numbers]
      session.delete :invalid_photo_order_numbers
    end

    if @contestant.entries.select { |p| p.registration_status != :confirmed }.any?
      flash.now[:alert] = "You currently have photo entries that are not completed. Please check the ACTIONS REQUIRED column in YOUR SUBMISSIONS"
    end
  end
end