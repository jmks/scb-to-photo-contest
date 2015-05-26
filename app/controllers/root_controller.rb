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

  def contact
    if ContactUs.new(params).call
      flash[:notice] = "Thank you contacting us. A representative from SCB-TO will respond shortly."
    else
      flash[:warning] = "Your email or message was invalid."
    end

    redirect_to root_path
  end
end
