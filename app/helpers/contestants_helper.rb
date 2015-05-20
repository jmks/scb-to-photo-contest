module ContestantsHelper

  def incomplete_entries_message
    incomplete_titles = capture do
      content_tag('ul') do
        @contestant.incomplete_entries.map do |entry|
          concat content_tag('li', entry.title)
        end
      end
    end

    capture do
      concat content_tag('h4', 'The following entries are incomplete:')
      concat incomplete_titles
      concat content_tag('h4', 'Please check the ACTIONS REQUIRED column in YOUR SUBMISSIONS')
    end
  end

  def next_action photo
    status  = photo.registration_status
    message = Photo::Registration_Message[status]

    case status
    when :submitted
      content_tag(:a, message, href: new_photo_entry_path(photo_id: photo.id))
    when :uploaded
      link_to message, order_path
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
end
