class ContestantsController < ApplicationController
  before_filter :authenticate_contestant!

  def index
    @contestant       = current_contestant
    @favourites       = Photo.find(@contestant.voted_photo_ids || [])
    votes             = Vote.find(request.remote_ip)
    @votes_left_today = votes ? ContestRules::VOTES_PER_DAY_PER_IP - votes.votes_today : ContestRules::VOTES_PER_DAY_PER_IP
  end
end