module ContestantsHelper
  def next_action photo
    status  = photo.registration_status
    message = Photo::Registration_Message[status]

    case status
    when :submitted
      "<a href='#{ new_photo_entry_path photo_id: photo.id }'>#{message}</a>".html_safe
    when :uploaded
      link_to message, 'http://downtowncamera.photofinale.com/prints', target: '_blank'
    when :printed
      message
    when :confirmed
      message
    end
  end

  def photo_link photo
    if photo.thumbnail_xs_url?
      link_to image_tag(photo.thumbnail_xs_url), photo_path(photo)
    else
      link_to photo.id, photo_path(photo)
    end
  end

  def human_date date
    date.strftime('%b %-d, %Y')
  end
end
