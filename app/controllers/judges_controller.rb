class JudgesController < ApplicationController
  before_filter :authenticate_judge!

  def index
  end

  def shortlist_photo
    photo    = Photo.find params[:photo_id]
    category = params[:category]
    @judge   = current_judge

    if @judge.shortlist_photo(photo, category.to_sym)
        flash[:alert] = "Successfully added photo to #{category.capitalize} shortlist"
    else
        # couldn't add - size or ??
        flash[:warning] = "Could not add photo to #{category.capitalize} shortlist"
    end
    redirect_back_or_home judge_root_path
  end

  def remove_from_shortlist
    photo    = Photo.find params[:photo_id]
    category = params[:category]
    @judge   = current_judge

    if @judge.remove_photo_from_shortlist(photo, category.to_sym)
        flash[:alert] = "Successfully added photo to #{category.capitalize} shortlist"
    else
        # couldn't add - size or ??
        flash[:warning] = "Could not add photo to #{category.capitalize} shortlist"
    end
    redirect_back_or_home judge_root_path
  end
end