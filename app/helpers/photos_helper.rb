module PhotosHelper
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
    ago = time - Time.now
    ago
  end
end
