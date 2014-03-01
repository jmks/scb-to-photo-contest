class PhotosController < ApplicationController
  before_filter :authenticate_contestant!, only: [:new, :create]
  before_filter :preprocess_data, only: [:create]

  PHOTOS_PER_PAGE = 15

  def new
    if params[:photo]
      @photo = Photo.new(params[:photo])
    else
      @photo = Photo.new
    end
  end

  def create
    @photo = Photo.new(params[:photo])
    @photo.owner = current_contestant
    if @photo.save
      redirect_to photo_path(@photo)
    else
      render :new, photo: @photo
    end
  end

  def show
    @photo = Photo.find(params[:id]) if params[:id]
    redirect_to(photos_path) and return unless @photo
    @photo.inc views: 1
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

  private

  def preprocess_data
    params[:photo][:tags]       = params[:photo][:tags].split(',').map { |tag| tag.strip }
    params[:photo][:category]   = params[:photo][:category].to_sym
    
    begin
      params[:photo][:photo_date] = Date.strptime(params[:photo][:photo_date], "%m/%d/%Y")
    rescue
      # keep the date as a string
    end

  end
end
