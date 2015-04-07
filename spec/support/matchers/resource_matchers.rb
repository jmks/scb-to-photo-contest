# TODO: custom error messages

RSpec::Matchers.define :have_error do |error|
  match do |resource|
    error = error.to_sym

    resource.errors.has_key?(error)
  end
end

RSpec::Matchers.define :have_error_message_for do |error, msg_matcher|
  match do |resource|
    error = error.to_sym

    resource.valid?
    return false unless resource.errors.has_key?(error)

    messages = resource.errors.full_messages_for(error)

    if msg_matcher.is_a? Regexp
      messages.any? { |m| m =~ msg_matcher }
    elsif msg_matcher.is_a? String
      messages.any? { |m| m.include?(msg_matcher) }
    else
      false
    end
  end
end