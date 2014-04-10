module PhotosHelper
  
  def months
    ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
  end

  # display helpers

  def display_photo_month
    (@photo.photo_date? && @photo.photo_date.split(' ').first) || Date.today.strftime('%B')
  end

  def display_photo_year
    (@photo.photo_date? && @photo.photo_date.split(' ').last) || Date.today.strftime('%Y')
  end  

  def photographer_link
    content_tag(:a, content_tag(:strong, @photo.owner.public_name), href: photos_path(contestant_id: @photo.owner.id))
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

  # params: filter, name, path, options, filter_sym, &block
  def filter_link_to *args, &block
    if block_given?
      filter, path, options = args

      if @filter == filter
        options[:class] = options.key?(:class) ? options[:class] + ' active' : 'active'
      end

      link_to path, options do
        yield
      end
    else
      filter, name, path, options = args

      if @filter == filter
        options[:class] = options.key?(:class) ? options[:class] + ' active' : 'active'
      end

      link_to name, path, options
    end
  end
end
