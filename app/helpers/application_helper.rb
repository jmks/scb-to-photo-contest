module ApplicationHelper
  def display_sponsors?
    [root_path, prizes_path].map { |path| current_page? path }.any?
  end

  def about_page?
    # better?
    [current_page?(about_path), current_page?(judges_path), current_page?(rules_path)].any?
  end
end
