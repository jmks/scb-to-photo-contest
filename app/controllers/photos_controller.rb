class PhotosController < ApplicationController

  def flora
    redirect_to photos_path(:category => :flora, :page => 1)
  end

  def fauna
    redirect_to photos_path(:category => :fauna, :page => 1)
  end

  def landscapes
    redirect_to photos_path(:category => :landscapes, :page => 1)
  end


  # photos should always be displayed by category
  def index
    # TODO add pagination with infinite-scroll or will_paginate

    @category = params[:category] || ""
    @category = Photo::CATEGORIES.include?(@category.to_sym) && @category.to_sym
    page      = params[:page].to_i

    if @category
      # display category-specific items
      @photos  = Photo.where(:category => @category).desc(:created_at).limit(15)
    else
      # category was nil or nonsense
      redirect_to root_path and return
    end
  end
end
