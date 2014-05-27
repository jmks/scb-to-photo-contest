class WinnersController < ApplicationController
  before_filter :authenticate_contestant!
  before_filter :admins_only!
  before_filter :get_admin

  def assign_winner
    @photo = Photo.find params[:photo_id]

    @winner = Winner.new category: params[:category].downcase.to_sym, prize: params[:prize].to_sym, photo: @photo

    if @winner.save
      flash[:notice] = "Assigned #{ pp_prize(params[:prize]) } to #{ @photo.title }"
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

  def notify_winners
    if @admin.notify_winners?
      flash[:alert] = "The winners have already been notified."
    else
      Winner.all.each do |winner|
        ContactMailer.notify_winner(winner).deliver
      end

      @admin.set notify_winners: true
      flash[:notice] = "The winners have been notified by email"
    end

    redirect_to admin_root_path
  end

  private

  def get_admin
    @admin = current_contestant
  end
end