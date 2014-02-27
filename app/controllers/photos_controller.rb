class PhotosController < ApplicationController
  #authorize on new
  PHOTOS_PER_PAGE = 15

  def new
  end

  def show
    @photo = Photo.find(params[:id])
    @photo.inc views: 1
    #render 'photo_mock' and return unless @photo
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

  def index
    # TODO add pagination with infinite-scroll or will_paginate

    @category = params[:category] || 'all'
    @category = Photo::CATEGORIES.include?(@category.to_sym) && @category.to_sym
    @tag      = params[:tag]
    page      = params[:page].to_i

    if @tag
      @photos = Photo.any_in(tags: [@tag])
    elsif @category
      @photos = Photo.where(:category => @category)
    else
      @photos = Photo.desc(:created_at)
    end

    @photos.skip(@page * PHOTOS_PER_PAGE) if @page
    @photos.desc(:created_at).limit(15)
  end
end
