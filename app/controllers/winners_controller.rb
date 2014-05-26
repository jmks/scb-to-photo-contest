class WinnersController < ApplicationController
  before_filter :authenticate_contestant!
  before_filter :admins_only!

  def assign_winner
    @photo = Photo.find params[:photo_id]

    @winner = Winner.new category: params[:category].to_sym, prize: params[:prize].to_sym, photo: @photo

    if @winner.save
      flash[:notice] = "Assigned #{ params[:prize] } to #{ @photo.title }"
    else
      flash.now[:alert] = "Could not assign prize: <ul>#{ @winner.errors.full_messages.map {|m| '<li>#{m}</li>'}.join }<ul>"
    end
    redirect_to admin_root_path
  end

  def remove_winner
    prize = params[:prize]

    winner = Winner.where(prize: prize)

    if winner.destroy
      flash[:notice] = "Removed photo for prize #{pp_prize(prize)}"
    end
    redirect_to admin_root_path
  end
end