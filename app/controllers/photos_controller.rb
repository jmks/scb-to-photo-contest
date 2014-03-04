class PhotosController < ApplicationController
  before_filter :authenticate_contestant!, only: [:new, :create, :comment]
  before_filter :preprocess_data, only: [:create]

  PHOTOS_PER_PAGE = 15

  def new
    if params[:photo]
      @photo = Photo.new(params[:photo])
    else
      @photo = Photo.new
    end

    #? @photo = Photo.new(params[:photo] || nil)
  end

  def create
    @photo = Photo.new(params[:photo])
    @photo.owner = current_contestant
    if @photo.save
      #redirect_to photo_path(@photo)

      # redirect to step #2
      redirect_to new_photo_entry_path photo_id: @photo.id
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

    @category   = params[:category] || 'all'
    @category   = Photo::CATEGORIES.include?(@category.to_sym) && @category.to_sym

    @contestant = Contestant.find(params[:contestant_id]) if params[:contestant_id]
    @tag        = params[:tag]
    page        = params[:page].to_i

    if @contestant
      @photos = @contestant.entries
      @title  = "Photos by #{ @contestant.public_name }"
    elsif @tag
      @photos = Photo.any_in(tags: [@tag])
      @title  = "Photos tagged #{ @tag }"
    elsif @category
      @photos = Photo.where(:category => @category)
      @title  = "Photos categorized #{ @category }"
    else
      @photos = Photo.desc(:created_at)
      @title  = "All Photos"
    end

    @photos.skip((@page - 1) * PHOTOS_PER_PAGE) if @page
    @photos.desc(:created_at).limit(15)
  end

  def comment
    @photo = Photo.find(params[:photo_id])
    @photo.comments.create name: current_contestant.public_name, text: params[:comment][:text]
    render :show
  end

  def vote
    @photo = Photo.find(params[:id])

    # move to own controller if any more complicated
    voter = Vote.find(request.remote_ip) || Vote.create(id: request.remote_ip)

    if voter.vote
      @photo.inc votes: 1
      flash[:notice] = "Thank you for voting"
    else
      flash[:danger] = "You have reached your vote limit for today. Please try again tomorrow."
    end
    
    # vote tracking for contestants
    current_contestant && current_contestant.vote_for(@photo)

    redirect_to @photo
  end

  private

  def preprocess_data
    params[:photo][:tags]       = params[:photo][:tags].split(',').map { |tag| tag.strip }
    params[:photo][:category]   = params[:photo][:category].downcase.to_sym
    
    begin
      params[:photo][:photo_date] = Date.strptime(params[:photo][:photo_date], "%m/%d/%Y")
    rescue
      # datepicker enforces date format
      # keep the date as a string
    end

  end
end
