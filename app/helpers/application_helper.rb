module ApplicationHelper
  def truncated_title title
        title.length > 25 ? "#{title[0..25]}..." : title
    end
    
  def display_sponsors?
    [root_path, prizes_path].map { |path| current_page? path }.any?
  end

  def about_page?
    # better?
    [current_page?(about_path), current_page?(judges_path), current_page?(rules_path)].any?
  end

  def background_class
    if on_photo_step?
      'rouge2005'
    elsif current_page?(about_path)
      'grey-bg'
    elsif current_page?(new_contestant_registration_path) || current_page?(new_contestant_session_path)
      'stjohnswart'
    else
      nil
    end
  end

  def on_photo_step?
    [new_photo_path, new_photo_entry_path, order_path, verify_path, share_photos_path].each do |path|
      return true if current_page? path
    end
    false
  end
end