class PhotosController < ApplicationController
  before_filter :authenticate_contestant!, except: [:show, :index, :vote, :report_comment, :flora, :fauna, :landscapes]
  before_filter :preprocess_data, only: [:create, :update]

  PHOTOS_PER_PAGE = 15

  def new
    @photo = Photo.new(params[:photo])
  end

  def create
    @photo = Photo.new(photo_params)
    @photo.owner = current_contestant
    
    if @photo.save
      # update tags
      Tag.add_tags params[:photo][:tags]

      # redirect to step #2
      redirect_to new_photo_entry_path(photo_id: @photo.id, referrer: :new)
    else
      render :new, photo: @photo
    end
  end

  def edit
    @photo = Photo.find params[:id]
  end

  def update
    @photo = Photo.find params[:id]

    if @photo.update_attributes(photo_params)
      # update tags
      Tag.add_tags params[:photo][:tags]
      
      redirect_to new_photo_entry_path(referrer: params[:referrer], photo_id: @photo.id)
    else
      render :edit
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
    @category   = (Photo::CATEGORIES.include?(@category.to_sym) && @category.to_sym) || nil

    @contestant = Contestant.find(params[:contestant_id]) if params[:contestant_id]
    @tag        = params[:tag]
    @page       = params.key?(:page) ? params[:page].to_i : 1

    if @contestant
      @photos = @contestant.entries
      @title  = @contestant.public_name
    elsif @tag
      @photos = Photo.any_in(tags: [@tag])
      @title  = @tag
    elsif @category
      @photos = Photo.where(category: @category)
      @title  = @category
    else
      @photos = Photo.all
      @title  = "All"
    end

    @photos = @photos.skip([@page - 1, 0].max * PHOTOS_PER_PAGE).
                      desc(:created_at).
                      limit(PHOTOS_PER_PAGE)

    @params = {
      tag:      @tag || nil,
      category: @category || nil,
      page:     @page,
      contestant_id: params[:contestant_id]
    }.reject { |key, val| val.nil? }

    @prev_params = @params.dup
    @prev_params[:page] -= 1

    @next_params = @params.dup
    @next_params[:page] += 1

    respond_to do |format|
      format.html
      format.js
    end
  end

  def destroy
    @photo = Photo.find params[:id]

    @photo.destroy
    flash[:danger] = "Your entry #{@photo.title} has been deleted"

    redirect_to contestant_index_path
  end

  def comment
    @photo = Photo.find(params[:photo_id])
    if params[:comment][:text].empty?
      flash.now[:alert] = "Please fill in a comment before commenting"
    else
      @photo.comments.create name: current_contestant.public_name, text: params[:comment][:text]
    end
    render :show
  end

  def vote
    @photo = Photo.find(params[:id])

    # move to own controller if any more complicated
    voter = begin
      Vote.find(request.remote_ip)
    rescue Mongoid::Errors::DocumentNotFound
      Vote.create(id: request.remote_ip)
    end

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

  def report_comment
    photo   = Photo.find(params[:photo_id])
    comment = photo.comments.find(params[:comment_id])

    comment.reported = true
    comment.save

    flash.now[:alert] = "Thank you for helping moderate comments. A SCB-TO admin will review the comment shortly."

    redirect_to photo
  end

  private

  def preprocess_data
    params[:photo][:tags]       = params[:photo][:tags].split(',').map { |tag| tag.strip }
    params[:photo][:category]   = params[:photo][:category].downcase.to_sym
    params[:photo][:photo_date] = "#{params[:photo_date_month]} #{params[:photo_date_year]}"
  end

  def photo_params
    params.require(:photo).permit(:title, :description, :photo_date, :photo_location, :camera_stats, :terms_of_service, :category, :tags => [])
  end
end
