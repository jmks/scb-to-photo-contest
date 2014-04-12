class PhotosController < ApplicationController
  before_filter :authenticate_contestant!, only: [:new, :create, :edit, :update, :destroy, :comment]
  
  before_filter :preprocess_data, only: [:create, :update]
  
  before_filter :get_photo_by_id, only: [:edit, :update, :show, :destroy, :comments, :vote]
  before_filter :contestant_owns_photo!, only: [:edit, :update, :destroy]

  PHOTOS_PER_PAGE = 15
  COMMENTS_PER_PAGE = 25

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
  end

  def update
    if @photo.update_attributes(photo_params)
      # update tags
      Tag.add_tags params[:photo][:tags]
      
      redirect_to new_photo_entry_path(referrer: params[:referrer], photo_id: @photo.id)
    else
      render :edit
    end
  end

  def show
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
    @category   = params[:category] || 'all'
    @category   = (Photo::CATEGORIES.include?(@category.to_sym) && @category.to_sym) || nil

    @contestant = Contestant.find(params[:contestant_id]) if params[:contestant_id]
    @tag        = params[:tag]
    @popular    = params[:popular]
    @page       = params.key?(:page) ? params[:page].to_i : 1

    if @contestant
      @photos = @contestant.entries
      @title  = @contestant.public_name
      @filter = :contestant
    elsif @tag
      @photos = Photo.any_in(tags: [@tag])
      @title  = @tag
      @filter = :tag
    elsif @category
      @photos = Photo.where(category: @category)
      @title  = @category
      @filter = @category.to_sym
    elsif @popular
      case @popular
      when 'votes'
        @photos = Photo.desc(:votes)
        @title  = @popular
        @filter = :votes
      when 'views'
        @photos = Photo.desc(:views)
        @title  = @popular
        @filter = :views
      else
        # params :popular => junk
        @photos = Photo.all
        @title  = "All"
        @filter = :all
      end
    else
      @photos = Photo.all
      @title  = "All"
      @filter = :all
    end

    photo_count  = @photos.skip([@page - 1, 0].max * PHOTOS_PER_PAGE).count
    @total_pages = (1.0 * photo_count / PHOTOS_PER_PAGE).ceil
    @photos = @photos.skip([@page - 1, 0].max * PHOTOS_PER_PAGE).
                      desc(:created_at).
                      limit(PHOTOS_PER_PAGE).
                      only(:id, :title, :views, :votes, :thumbnail_sm_url)

    @params = {
      tag:      @tag,
      category: @category,
      page:     @page,
      contestant_id: @contestant && @contestant.id,
      popular: @popular
    }.reject { |key, val| val.nil? }

    @prev_params = @params.dup
    @prev_params[:page] -= 1

    @next_params = @params.dup
    @next_params[:page] += 1

    if request.xhr?
      render partial: 'photos_only' and return
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
      flash.now[:alert] = "Please fill in a comment before commenting"
    else
      @photo.comments.create name: current_contestant.public_name, text: params[:comment][:text]
    end
    redirect_to photo_path @photo
  end

  def vote
    voter = Vote.first_or_initialize(request.ip)

    if voter.vote
      @photo.inc votes: 1
      flash[:notice] = "Thank you for voting"
    else
      flash[:danger] = "You have reached your vote limit for today. Please try again tomorrow."
    end

    voter.save
    
    # vote tracking for contestants
    current_contestant.vote_for(@photo) if contestant_signed_in?

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
    params[:photo][:tags]       = params[:photo][:tags].split(',').map(&:strip).uniq
    params[:photo][:category]   = params[:photo][:category].downcase.to_sym
    params[:photo][:photo_date] = "#{params[:photo_date_month]} #{params[:photo_date_year]}"
  end

  def get_photo_by_id
    @photo = Photo.find(params[:id])
  end

  def contestant_owns_photo!
    redirect_to photos_path unless contestant_signed_in? && current_contestant.id == @photo.id
  end

  def photo_params
    params.require(:photo).permit(:title, :description, :photo_date, :photo_location, :camera_stats, :terms_of_service, :category, :tags => [])
  end
end
