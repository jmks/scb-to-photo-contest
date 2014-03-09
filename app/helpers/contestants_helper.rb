module ContestantsHelper
  def registration_status photo
    # must have filled out initial form
    # TODO must check photo uploaded and paid?
    photo.original_url?
  end

  def next_action photo
    if !photo.original_url
      "<a href='#{ new_photo_entry_path photo_id: photo.id }'>Upload your photo</a>".html_safe
    elsif photo.respond_to?(:paid?) && photo.paid?
      # payment
      "You need to pay!"
    else
      "Registration Complete"
    end
  end


  def human_date date
    date.strftime('%b %-d, %Y')
  end
end
