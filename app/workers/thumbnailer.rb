require 'rmagick'

class Thumbnailer
  @queue = :thumbnails_queue

  Original_Bucket  = 'scbto-photos-originals'
  Thumbnail_Bucket = 'scbto-photos-thumbs'

  def self.perform photo_id
    photo = Photo.find(photo_id)

    s3 = AWS::S3.new

    # make sure thumbs bucket available
    s3.buckets.create(Thumbnail_Bucket, :acl => :public_read) unless s3.buckets[Thumbnail_Bucket].exists?

    uploads = s3.buckets[Original_Bucket]
    thumbs = s3.buckets[Thumbnail_Bucket]

    original_img = uploads.objects[photo.original_key].read

    # open as image
    img = Magick::Image::from_blob(original_img).first

    # strip metadata
    img.strip!

    # composite for large image
    img_lg = img.resize_to_fit 1000
    comp   = Magick::Image.new(img_lg.columns, img_lg.rows) do
      self.background_color = 'none'
      self.density = '96x96'
    end
    img_lg = comp.composite(img_lg, Magick::CenterGravity, Magick::OverCompositeOp)
    img_lg.format = 'JPG'

    # size lg => max 1000x1000
    aws_lg = thumbs.objects[photo.aws_key(:lg) + '.jpg']
    aws_lg.write(img_lg.to_blob { self.quality = 90 }, acl: :public_read)
    photo.thumbnail_lg_url = aws_lg.public_url.to_s

    # size xs => max 100x100
    aws_xs = thumbs.objects[photo.aws_key(:xs) + '.jpg']
    aws_xs.write(img_lg.resize_to_fit(100, 100).to_blob { self.quality = 90 }, acl: :public_read)
    photo.thumbnail_xs_url = aws_xs.public_url.to_s

    # size sm => max 240x240 with cropping
    aws_sm = thumbs.objects[photo.aws_key(:sm) + '.jpg']
    img_sm = img.resize_to_fill(240, 240)
    img_sm.format = 'JPG'
    aws_sm.write(img_sm.to_blob { self.quality = 90 }, acl: :public_read)
    photo.thumbnail_sm_url = aws_sm.public_url.to_s

    photo.save

  rescue Resque::TermException
    Resque.enqueue(self, photo_id)
  end
end
