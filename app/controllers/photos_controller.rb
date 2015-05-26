class PhotosController < ApplicationController
  before_filter :authenticate_contestant!, only: [:new, :create, :edit, :update, :destroy, :comment]
  before_filter :sanitize_photo_params,    only: [:create, :update]
  before_filter :get_photo_by_id,          only: [:edit, :update, :show, :destroy, :comments, :vote]
  before_filter :contestant_owns_photo!,   only: [:edit, :update, :destroy]
  before_filter :only_contest_open!,       only: [:new, :create, :edit, :update, :destroy]

  PHOTOS_PER_PAGE = 15
  COMMENTS_PER_PAGE = 25

  def new
    can_add_entries!

    @photo = Photo.new(params[:photo])
  end

  def create
    can_add_entries!

    @photo = Photo.new(photo_params)
    @photo.owner   = current_contestant
    @photo.contest = current_contest

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
  end

  def update
    if @photo.update_attributes(photo_params)
      Tag.add_tags params[:photo][:tags]

      redirect_to new_photo_entry_path(referrer: params[:referrer], photo_id: @photo.id)
    else
      render :edit
    end
  end

  def show
    redirect_to(photos_path) and return unless @photo
    @photo.inc views: 1

    @winner = Winner.where(photo: @photo).first
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
    filter = FilterPhotos.new(params).call
    @gallery = PhotoGallery.new(params, filter)

    respond_to do |format|
      format.html { render partial: "photos_only", layout: false } if request.xhr?
      format.html
    end
  end

  def destroy
    redirect_to contestant_index_path unless @photo.owner.id == current_contestant.id

    @photo.destroy
    flash[:danger] = "Your entry #{@photo.title} has been deleted"

    redirect_to contestant_index_path
  end

  def comments
    page = (params[:page] && params[:page].to_i) || 1

    @comments = @photo.comments.skip((page - 1) * COMMENTS_PER_PAGE).limit(COMMENTS_PER_PAGE)

    render partial: 'comments', layout: false
  end

  def comment
    @photo = Photo.find(params[:photo_id])
    if params[:comment][:text].empty?
      flash.now[:alert] = 'Please fill in a comment before commenting'
    else
      @photo.comments.create name: current_contestant.public_name, text: params[:comment][:text]
    end
    redirect_to photo_path @photo
  end

  def vote
    unless ContestRules.voting_open?
      flash[:alert] = 'Voting is now closed'
      redirect_back_or_home and return
    end

    voter = Vote.where(id: params[:remote_ip]).first || Vote.new(id: params[:remote_ip])

    if voter.vote
      @photo.inc votes: 1
      current_contestant.vote_for(@photo) if contestant_signed_in?

      success = true
      flash[:notice] = message = 'Thank you for voting'
    else
      success = false
      flash[:alert] = message = 'You have reached your vote limit for today. Please try again tomorrow.'
    end

    voter.save

    if request.xhr?
      flash.clear
      render :json => { success: success, message: message, votes: @photo.votes }
    else
      redirect_to @photo
    end
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

  def sanitize_photo_params
    params[:photo][:tags]       = params[:photo][:tags].split(',').map(&:strip).uniq
    params[:photo][:category]   = params[:photo][:category].downcase.to_sym
    params[:photo][:photo_date] = "#{params[:photo_date_month]} #{params[:photo_date_year]}"
  end

  def get_photo_by_id
    @photo = Photo.find(params[:id])
  end

  def get_contestant
    Contestant.find(params[:contestant_id])
  end

  def can_add_entries!
    unless current_contest?
      flash[:danger] = "There is currently no contest running!"
      redirect_to contestant_index_path and return
    end

    unless current_contestant.entries_left?
      flash[:danger] = "You have reached the contest's entry limit of #{ ContestRules::ENTRIES_PER_CONTESTANT }"
      redirect_to contestant_index_path and return
    end
  end

  def contestant_owns_photo!
    redirect_to photos_path unless signed_in? && current_contestant.entries.include?(@photo)
  end

  def photo_params
    params.require(:photo).permit(:title, :description, :photo_date, :photo_location, :camera_stats, :category, :tags => [])
  end
end
