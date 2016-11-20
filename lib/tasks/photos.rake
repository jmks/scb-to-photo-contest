BACKUP_DIR = "original_photos"

namespace :photos do
  desc "Downloads contestant original photos locally to original_photos/"
  task :backup_originals => :environment do
    if `which wget`.blank?
      abort("This task requires wget to fetch the images from S3")
    end

    Dir.mkdir(BACKUP_DIR) unless Dir.exists?(BACKUP_DIR)

    Photo.submitted.each do |photo|
      next if File.exists?(photo_backup_path(photo))
      `wget --output-document="#{photo_backup_path(photo)}" #{photo.original_url}`
    end
  end
end

def photo_backup_path(photo, base = BACKUP_DIR)
  Pathname.new(base).join(photo.backup_filename)
end
