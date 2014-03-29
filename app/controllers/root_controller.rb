class RootController < ApplicationController
  def index
  end

  def rules
  end

  def prizes
  end

  def judges
  end

  def contact
    email, message = params[:email], params[:message]
    
    Email.create(email: email, message: message)

    begin
      ContactMailer.contact(email, message).deliver
      flash[:notice] = "Thank you contacting us. A representative from SCB-TO will respond shortly."
    rescue
      # TODO log it
    end

    redirect_to root_path
  end
end