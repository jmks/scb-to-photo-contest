class ContestantsController < ApplicationController
  before_filter :authenticate_contestant!

  def index
  end

  # deprecated afterwards

  def new
    @contestant = Contestant.new
  end

  def create
    # TODO: should have model solution
    # TODo: email verification? => Devise
    contestant = params[:contestant]

    salt = contestant[:password_salt] = User.get_salt
    contestant[:password_hash] = User.encrypt_password(contestant[:password], salt)

    # add to custom model for validates_password?
    contestant.delete :password
    contestant.delete :password_confirmation

    @contestant = Contestant.new contestant
    if @contestant.save
      redirect_to root_url, :notice => "You have successfully signed up. You may now log in."
    else
      render "new", contestant: @contestant
    end
  end

  def signin
    # TODO: Devise / Omniauth solution
    @user = User.where(email: params[:email]).first
    if @user
      password_hash = User.encrypt_password(params[:password], @user.password_salt)

      if password_hash == @user.password_hash
        flash[:notice] = "Successfully logged in. Welcome #{@user.first_name}"
        redirect_to :root
      else
        flash[:alert] = "The entered password was not correct"
        render :signin_form and return
      end
    else
      flash[:alert] = "Email not found"
      render :signin_form
    end
  end

  private
  # whitelist strong params
  # make sure to block votes, favourites, 
  # def contestant_params
  #   params.require(:contestant).permit!
  # end
end