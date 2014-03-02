class ContestantsController < ApplicationController
  before_filter :authenticate_contestant!

  def index
  end
end