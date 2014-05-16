class Judges::SessionsController < Devise::SessionsController
  
  def resource_name
    :judge
  end

  def resource
    @resource ||= Judge.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:judge]
  end
end