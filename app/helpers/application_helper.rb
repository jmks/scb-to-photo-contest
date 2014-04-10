module ApplicationHelper
  def truncated_title title
        title.length > 25 ? "#{title[0..25]}..." : title
    end
    
  def display_sponsors?
    [root_path, prizes_path].map { |path| current_page? path }.any?
  end

  def about_page?
    # better?
    [current_page?(about_path), current_page?(rules_path)].any?
  end

  def navbar_class
    if current_page? root_path
      'navbar-inverse'
    else
      ''
    end
  end

  def background_class
    if on_photo_step?
      'rouge2005'
    elsif current_page?(about_path) || current_page?(contest_path) || current_page?(rules_path)
      'grey-bg'
    elsif current_page?(new_contestant_registration_path) || current_page?(new_contestant_session_path)
      'fieldsite'
    elsif current_page?(judges_path) || current_page?(prizes_path)
      'fieldsite'
    elsif current_page?(photos_path) || current_page?(contestant_index_path)
      'light-grey-bg'
    elsif current_page? root_path
      'home'
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

  def svg_png_fallback svg_path, html_attrs, fallback_data_attr='fallback'
    attributes = html_attrs.merge 'src' => asset_path(svg_path), 'data' => { fallback_data_attr => asset_path(svg_path.gsub(/svg\Z/, 'png')) }
    tag('img', attributes)
  end
end