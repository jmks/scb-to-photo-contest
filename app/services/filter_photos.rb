class FilterPhotos
  attr_reader :title, :photos, :filter

  def initialize(params)
    @params = params
  end

  def call
    @title, @photos, @filter = [
      by_contestant,
      by_tag,
      by_category,
      by_popularity,
      by_default
    ].find { |el| el }
    self
  end

  private

  def by_contestant
    return false unless @params[:contestant_id]
    contestant = Contestants.find(@params[:contestant_id])
    # TODO: eager loading with find?
    [contestant, contestant.entries, :contestant]
  end

  def by_tag
    return false unless @params[:tag]
    [@params[:tag].titleize, Photo.tagged(@params[:tag]), :tag]
  end

  def by_category
    return false unless @params[:category]
    return false unless Photo.category?(@params[:category].downcase)

    [@params[:category].try(:titleize), Photo.category(@params[:category].downcase), @params[:category].downcase.to_sym]
  end

  def by_popularity
    case @params[:popular].try(:downcase)
    when "votes"
      ["Votes", Photo.most_voted, :votes]
    when "views"
      ["Views", Photo.most_viewed, :views]
    else
      false
    end
  end

  def by_default
    ["All", Photo.all, :all]
  end
end