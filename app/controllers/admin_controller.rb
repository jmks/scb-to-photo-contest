class AdminController < ApplicationController
  def report_comment
    admin = Admin.first || Admin.new

    admin['type'] = 'comment'
    admin['comment_id'] = params[:id]
    admin.save

    flash[:alert] = "Thank you for helping moderate comments. A SCB-TO admin will review the comment shortly."

    # redirect back to referrer
    if !request.env["HTTP_REFERER"].blank? and request.env["HTTP_REFERER"] != request.env["REQUEST_URI"]
      redirect_to :back
    else
      redirect_to root_path
    end
  end
end