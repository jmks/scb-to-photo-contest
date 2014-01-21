class ContestantsController < ApplicationController
  def new
    @contestant = Contestant.new
  end

  def create
    raise UnimplementedError
    @contestant = Contestant.new params[:user]
    if @contestant.save
      redirect_to root_url, :notice => "You have successfully signed up. You may now log in."
    else
      render "new"
    end
  end

  def signin_form
  end

  def signin
  end
end