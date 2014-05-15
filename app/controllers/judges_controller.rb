class JudgesController < ApplicationController
  before_filter :authenticate_judge!

  def index
    render :index
  end
end