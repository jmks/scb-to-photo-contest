class ContestantsController < ApplicationController
  before_filter :authenticate_contestant!

  def index
    @contestant       = current_contestant
    @favourites       = Photo.find(@contestant.voted_photo_ids || [])
    votes             = Vote.where(_id: request.remote_ip).first
    @votes_left_today = ContestRules::VOTES_PER_DAY_PER_IP - (votes ? votes.votes_today : 0)
  end
end