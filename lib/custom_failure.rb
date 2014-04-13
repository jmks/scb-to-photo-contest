class CustomFailure < Devise::FailureApp
  def redirect_url
    new_contestant_registration_path
  end

  def respond
    if http_auth?
      http_auth
    else
      redirect
    end
  end
end