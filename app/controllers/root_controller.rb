class RootController < ApplicationController
  def index
  end

  def rules
  end

  def prizes
  end

  def judges
  end

  def about
  end

  def contest
  end

  def judging_criteria
  end

  def winners
  end

  def contact
    email, message = params[:email].strip, params[:message].strip

    if !valid_email(email) or message.empty?
      if request.xhr?
        head :bad_request and return
      else
        flash[:warning] = 'Your email or message was invalid.'
        redirect_to root_path and return
      end
    end
    
    Email.create(email: email, message: message)

    begin
      ContactMailer.contact(email, message).deliver
      flash[:notice] = "Thank you contacting us. A representative from SCB-TO will respond shortly."
    rescue
      # TODO log it - email created in db
    end

    if request.xhr?
      head :ok and return
    else
      redirect_to root_path
    end
  end

  private

  def valid_email email
    email =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  end
end