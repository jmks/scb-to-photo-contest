class PhotoEntryController < ApplicationController
  before_filter :authenticate_contestant!

  def new
    redirect_to contestant_index_path(@contestant) and return unless params[:photo_id]

    @contestant = current_contestant
    @photo      = Photo.find(params[:photo_id])

    redirect_to contestant_index_path(@contestant) and return unless @photo
    
    @uploader = Photo.new.photo
    @uploader.success_action_redirect = photo_entry_path
  end

  # not from a post!
  def create
    if params[:key].nil? || params[:photo_id].nil?
      flash[:notice] = "Invalid photo creation request. Please reupload your photo."
      redirect_to contestant_index_path and return
    end

    photo_aws_key = params[:key]
    photo_id      = params[:photo_id]

    
  end
end