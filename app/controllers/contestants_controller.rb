class ContestantsController < ApplicationController
  before_filter :authenticate_contestant!

  def index
  end

  # vote by ip
  # request.remote_ip
end