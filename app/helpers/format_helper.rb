module FormatHelper
  def long_date date
    date.strftime("%B %-d, %Y")
  end

  def truncate(string, options = {})
    options = {
      max_length: 25,
      postfix: "..."
    }.merge(options)

    return string if string.length <= options[:max_length]

    prefix_length = options[:max_length] - options[:postfix].length
    if prefix_length > 0
      prefix = string[0...prefix_length]
      prefix.concat options[:postfix]
    else
      options[:postfix][0...options[:max_length]]
    end
  end
end
