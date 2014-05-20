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

    category_photos = Judge.shortlist(current_photo.category)
    photo_index = category_photos.index(current_photo)
    if photo_index.nil? # photo was in canada category, but not specific category
      Judge.shortlist(:canada).each do |photo|
        if PhotoScore.where(judge_id: @judge.id.to_s, photo_id: photo.id.to_s).first.nil?
          return photo_score_path(id: photo.id)
        end
      end
      # canada done as well
      return judge_root_path
    elsif photo_index == (category_photos.length - 1)
      next_photo = category_photos[photo_index + 1]
      return photo_score_path(id: next_photo.id)
    end

    category_index = Photo::CATEGORIES.index(@photo.category)
    if category_index == (Photo::CATEGORIES.length - 1)
      judge_root_path
    else
      next_photo = Judge.shortlist(Photo::CATEGORIES[category_index + 1]).first
      photo_score_path(id: next_photo.id)
    end
  end

  def get_judge_photo
    @judge = current_judge
    @photo = Photo.find params[:id] if params[:id]
  end
end