class TagController < ApplicationController

  def index
    render :json => Tag.get_tags
  end
end