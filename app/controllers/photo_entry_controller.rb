class PhotoEntryController < ApplicationController
  before_filter :authenticate_contestant!

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

  def create
    unless params[:url] && session[:photo_id]
      flash[:notice] = "Invalid photo creation request. Please reupload your photo."
      redirect_to contestant_index_path and return
    end

    @photo = Photo.find(session[:photo_id])

    @photo.original_url      = params[:url]

    # TODO want original_key
    @photo.original_filename = params[:filename]
    
    @photo.save

    session.delete :photo_id

    Resque.enqueue(ThumbnailJob, @photo.id.to_s)

    redirect_to contestant_index_path
  end
end