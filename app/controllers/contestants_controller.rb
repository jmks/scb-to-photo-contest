class ContestantsController < ApplicationController
  before_filter :authenticate_contestant!

  def index
    @contestant = current_contestant

    if @contestant.admin?
      redirect_to admin_root_path and return
    end

    @favourites       = Photo.find(@contestant.voted_photo_ids || [])
    @votes_left_today = Vote.votes_remaining(@contestant.current_sign_in_ip)

    # can be removed
    if session[:invalid_photo_order_numbers]
      @invalid_photo_order_numbers = session[:invalid_photo_order_numbers]
      session.delete :invalid_photo_order_numbers
    end
  end
end