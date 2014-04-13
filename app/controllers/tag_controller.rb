class TagController < ApplicationController

  def index
    if params[:q]
        render :json => Tag.where(name: /#{Regexp.escape(params[:q])}/i).map(&:name)
    else
        render :json => Tag.get_tags
    end
  end
end