module PhotosHelper

  def photographer_link
    "Photographed by <a href='#{ photos_path contestant_id: @photo.owner.id }'><strong>#{ @photo.owner.public_name }</strong></a>".html_safe
  end

  def display_photo_date default
    date = @photo.photo_date? && @photo.photo_date.strftime('%b %-d, %Y')
    date || default
  end

  def method_missing method, *args, &block
    if method.to_s =~ /^display_(.*)$/
      display($1, args.first)
    else
      super
    end
  end

  def display property, default
    if @photo.respond_to?("#{property}?".to_sym) and @photo.send(property.to_sym)
      @photo.send(property.to_sym)
    else
      default
    end
  end

  def time_ago time
    "#{time_ago_in_words time} ago"
  end

  def tags_string photo
    photo.tags? ? photo.tags.join(', ') : ''
  end
end
