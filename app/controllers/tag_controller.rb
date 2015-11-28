class TagController < ApplicationController
  def index
    if params.has_key?("q")
      tags = Tag.where(name: escaped_query)
      render json: tags.map(&:name)
    else
      render json: Tag.get_tags
    end
  end

  private

  def escaped_query
    /#{Regexp.escape(params["q"])}/i
  end
end
