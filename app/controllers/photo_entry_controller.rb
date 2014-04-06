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

    Resque.enqueue(Thumbnailer, @photo.id.to_s)

    if request.xhr?
      flash[:notice] = "Photo '#{@photo.title}' successfully received. It's thumbnails will be generated shortly."
      flash.keep(:notice) # Keep flash notice around for the redirect.
      render :js => "window.location = #{ order_path.to_json }"
    else
      redirect_to order_path
    end
  end

  # photo submission step 3 - order display print
  def order
  end

  def verify
    @entries = contestant_unverified_photos
    @errors  = nil
  end

  # photo submission step 4.5 - verify
  def verify_orders
    photos = params.select { |key, val| key =~ /^[a-f0-9]{24}/ }

    invalid_photo_order_numbers = []

    photos.each_pair do |key, val|
      val.strip!
      if val.empty? || !(val =~ /^\d{8}$/ )
        invalid_photo_order_numbers << key
        next
      end
      photo = Photo.find(key)
      next if photo.order_number == val
      photo.set order_number: val
    end

    if invalid_photo_order_numbers.any?
      @entries = contestant_unverified_photos
      @errors = invalid_photo_order_numbers
      render :verify and return
    end

    # remove
    session[:invalid_photo_order_numbers] = invalid_photo_order_numbers

    flash[:notice] = 'Order Numbers successfully verified. Thank you.'
    redirect_to share_photos_path
  end

  def share
  end

  private

  def contestant_unverified_photos
    current_contestant.entries.select { |entry| entry.order_number.nil? }
  end
end