class PhotosController < ApplicationController
  #authorize on new

  def new
  end

  def show
    @photo = Photo.find(params[:id]) || Photo.new
    #render 'photo_mock' unless @photo
  end

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

    @category = params[:category] || 'all'
    @category = Photo::CATEGORIES.include?(@category.to_sym) && @category.to_sym
    page      = params[:page].to_i

    case @category
      when :all
        @photos = Photo.desc(:created_at)
      else
        @photos = Photo.where(:category => @category)
      end
    @photos.desc(:created_at).limit(15)

  end
end
