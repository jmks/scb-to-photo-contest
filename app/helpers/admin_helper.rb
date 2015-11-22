module AdminHelper
  def photo_view photo
    if photo.thumbnail_xs_url?
      image_tag photo.thumbnail_xs_url, title: truncate(photo.title)
    else
      truncate photo.title
    end
  end

  def status_options photo
    unless photo.registration_status == :confirmed
      link_to 'Grant confirmation', admin_confirm_photo_path(photo.id), class: 'photo-confirmation btn btn-primary', method: :post
    end
  end
end
