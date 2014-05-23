class JudgeScoreController < ApplicationController
  before_filter :authenticate_judge!
  before_filter :get_judge_photo

  def score_photo
    @photo_score   = PhotoScore.where(judge_id: @judge.id.to_s, photo_id: @photo.id.to_s).first
    @photo_score ||= PhotoScore.new(judge_id: @judge.id.to_s, photo_id: @photo.id.to_s)
  end

  def save_photo_score
    @photo_score   = PhotoScore.where(judge_id: @judge.id.to_s, photo_id: @photo.id.to_s).first
    @photo_score ||= PhotoScore.new photo_score_params

    @photo_score.update_attributes photo_score_params

    if @photo_score.save
      redirect_to score_next_photo_path(@photo) and return
    else
      render :score_photo
    end
  end

  def finalize_photo_scores
    if @judge.final_score_complete?
      @judge.set photo_scoring_complete: true
      flash[:notice] = "Your photo scores have been submitted. We'll inform you when all the final scores are tallied."
    else
      flash[:alert] = "There are Photos that still need to be scored"
    end
    redirect_to judge_root_path
  end

  private

  def photo_score_params
    params.require(:photo_score).permit(:photo_id, :judge_id, :technical_excellence, :subject_matter, :composition, :overall_impact)
  end

  # score next photo in category, then next category,
  # otherwise back to judge home
  # returns path
  def score_next_photo_path current_photo=nil

    return judge_root_path if current_photo.nil?

    shortlist = Judge.shortlist_by_category

    photo_index   = shortlist[current_photo.category].index(current_photo)
    category      = photo_index.nil? ? :canada : current_photo.category
    photo_index ||= shortlist[:canada].index(current_photo)

    if photo_index == shortlist[category].length - 1
      # next category
      next_category_index = Photo::CATEGORIES.index(category) + 1

      # no more categories
      return judge_root_path if next_category_index == Photo::CATEGORIES.length

      # first photo from next category
      return photo_score_path(id: shortlist[Photo::CATEGORIES[next_category_index]].first.id)
    end

    # next photo
    return photo_score_path(id: shortlist[category][photo_index + 1].id)
  end

  def get_judge_photo
    @judge = current_judge
    @photo = Photo.find params[:id] if params[:id]
  end
end