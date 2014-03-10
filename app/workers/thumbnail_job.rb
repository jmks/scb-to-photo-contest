class ThumbnailJob
  @queue = :thumbnails_queue

  Original_Bucket  = 'scbto-photos-originals'
  Thumbnail_Bucket = 'scbto-photos-thumbs'
  Thumbnail_Sizes = {
    :xs => 100,
    :sm => 200,
    :lg => 800
  }
  
  def self.perform photo_id
    photo = Photo.find(photo_id)
    
    # s3
    s3 = AWS::S3.new

    # make sure thumbs bucket available
    s3.buckets.create(Thumbnail_Bucket, :acl => :public_read) unless s3.buckets[Thumbnail_Bucket].exists?
    
    thumbs = s3.buckets[Thumbnail_Bucket]

    # fetch file from s3
    original_img = s3.buckets[Original_Bucket].objects[photo.original_key].read

    # read thumbnails
    img = Magick::Image::read(original_img).first

    # make max 800x800, 200x200, 100x100
    Thumbnail_Sizes.each_pair do |name, size|
      thumb = img.resize_to_fit(size, size)

      # add watermark
      # thumb = get_watermarked(thumb, photo.owner.full_name)

      # rename '#{username.id}-#{size}'

      # save to s3
      obj = thumbs.objects.create(photo.id + "-#{ name.to_s }-" + file_ext, thumb)

      # save urls
      photo["thumbnail_#{ name.to_s }_url"] = obj.public_url.to_s
    end

    photo.save
  end

  private

  def self.get_watermarked(image, copyright_name)

  end
end