class RegistrationsController < Devise::RegistrationsController
  def create
    @contestant = Contestant.new(contestant_params)

    if verify_recaptcha model: @contestant, message: "There was an error processing the Recaptcha. Please try again!"
      super
    else
      build_resource(sign_up_params)
      clean_up_passwords(resource)

      flash.now[:alert] = "There was an error with the recaptcha code below. Please re-enter the code."
      flash.delete :recaptcha_error

      render :new
    end
  end

  protected

  def contestant_params
    params.require(:contestant).permit(:first_name, :last_name, :public_name, :email, :phone, :password, :password_confirmation, :terms_of_service)
  end
end
