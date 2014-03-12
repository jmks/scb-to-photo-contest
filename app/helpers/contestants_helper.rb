module ContestantsHelper
  def next_action photo
    status  = photo.registration_status
    message = Photo::Registration_Message[status]

    case status
    when :submitted
      "<a href='#{ new_photo_entry_path photo_id: photo.id }'>#{message}</a>".html_safe
    when :uploaded
      link_to message, 'http://www.downtowncamera.com', target: '_blank'
    when :printed
      message
    when :confirmed
      message
    end
  end


  def human_date date
    date.strftime('%b %-d, %Y')
  end
end
