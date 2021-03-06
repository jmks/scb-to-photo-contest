class Judges::SessionsController < Devise::SessionsController

  def create
    #pry
    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_flashing_format?
    sign_in(resource_name, resource)
    yield resource if block_given?
    respond_with resource, location: after_sign_in_path_for(resource)
  end

  def resource_name
    :judge
  end
  
  # def resource
  #   @resource ||= Judge.new
  # end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:judge]
  end
end