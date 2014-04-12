class TagController < ApplicationController

  def index
    if params[:q]
        render :json => Tag.where(name: /#{params[:q]}/).map(&:name)
    else
        render :json => Tag.get_tags
    end
  end
end