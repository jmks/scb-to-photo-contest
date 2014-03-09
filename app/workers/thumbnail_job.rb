class ThumbnailJob
  @queue = :thumbnails_queue
  
  def self.perform(photo_id)
    photo = Photo.find(photo_id)

    # make thumbnails
    # TODO
  end 
end