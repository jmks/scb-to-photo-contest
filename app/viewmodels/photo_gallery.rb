class PhotoGallery
  attr_reader :title, :photos, :filter, :page, :total_pages

  def initialize(params, photo_filter=nil)
    if photo_filter
      @title  = photo_filter.title
      @photos = photo_filter.photos
      @filter = photo_filter.filter
    end

    # TODO: fix this
    @page_size = PhotosController::PHOTOS_PER_PAGE

    extract_params(params)
  end

  def more_pages?
    page < total_pages
  end

  def previous_pages?
    page > 1
  end

  def previous_params
    pparams = @params.dup
    pparams[:page] -= 1
    pparams
  end

  def next_params
    nparams = @params.dup
    nparams[:page] += 1
    nparams
  end

  def tag
    @params[:tag]
  end

  private

  # TODO: extraction needs tidying up
  def extract_params params
    @params = params.except(:controller, :action)

    @page = @params[:page] = @params[:page] ? params[:page].to_i : 1

    photo_count  = @photos.recent.skip([@page - 1, 0].max * @page_size).count
    @total_pages = (1.0 * photo_count / @page_size).ceil

    @photos = @photos.recent.
                      limit(@page_size).
                      only(:id, :title, :views, :votes, :thumbnail_sm_url)

    @tag        = @params[:tag]     = params[:tag]
    @popular    = @params[:popular] = params[:popular]
    @contestant = Contestant.find(params[:contestant_id]) if params[:contestant_id]
    @category   = @params[:category] = params[:category].downcase if Photo.category?(params[:category])

    @params[:contestant_id] = @contestant.id if @contestant

    @params.keep_if { |key, val| val }
  end
end