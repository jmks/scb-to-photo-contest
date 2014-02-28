module ApplicationHelper
  def display_sponsors?
    [root_path, prizes_path, rules_path, judges_path].map { |path| current_page? path }.any?
  end
end
