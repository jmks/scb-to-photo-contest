module ContestantsHelper
  def registration_status photo
    photo.photo?
  end
end
