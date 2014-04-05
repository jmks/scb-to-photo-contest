module ApplicationHelper
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
    else
      nil
    end
  end

  def on_photo_step?
    [current_page?(new_photo_path), current_page?(new_photo_entry_path), current_page?(print_photo_entry_path), current_page?(verify_photo_entry_path), current_page?(share_photo_entry_path)].any?
  end
end