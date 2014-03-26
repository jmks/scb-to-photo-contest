class PhotoEntryController < ApplicationController
  before_filter :authenticate_contestant!, except: [:workflow]

  # photo submission step 0 - submission process
  def workflow
  end

  # photo submission step 2 - display upload form
  def new
    redirect_to contestant_index_path and return unless params[:photo_id]

    @contestant = current_contestant
    @photo      = Photo.find(params[:photo_id])

    # TODO flash messages
    unless @photo && @photo.owner.id == @contestant.id
      redirect_to contestant_index_path and return
    end

    session[:photo_id] = @photo.id
  end

  # photo submission step 2.5 - save uploaded info, move to step #3
  def create
    unless params[:url] && session[:photo_id]
      flash[:notice] = "Invalid photo creation request. Please reupload your photo."
      redirect_to contestant_index_path and return
    end

    @photo = Photo.find(session[:photo_id])

    @photo.original_url = params[:url]

    # TODO want original_key
    @photo.original_filename = params[:filename]
    
    @photo.save

    session.delete :photo_id

    Resque.enqueue(ThumbnailJob, @photo.id.to_s)

    if request.xhr?
      flash[:notice] = "Photo '#{@photo.title}' successfully received. It's thumbnails will be generated shortly."
      flash.keep(:notice) # Keep flash notice around for the redirect.
      render :js => "window.location = #{ contestant_index_path.to_json }"
    else
      redirect_to contestant_index_path
    end
  end

  # photo submission step 3 - display print and verify
  def print_and_verify
    @entries = current_contestant.entries
  end

  # photo submission step 3.5 - verify
  def verify

    photos = params.select { |key, val| key =~ /^[a-f0-9]{24}/ }

    photos.each_pair do |key, val|
      val.strip!
      next if val.empty? || !(val =~ /^\d{8}$/ )
      photo = Photo.find(key)
      next if photo.order_number == val
      photo.set order_number: val
      flash[:notice] = 'Thank-you for completing your submission. Good luck!'
    end

    unless flash[:notice]
      flash[:alert] = 'Order Number could not be verified. Please verify and re-enter your Order Number.'
    end

    redirect_to contestant_index_path
  end
end