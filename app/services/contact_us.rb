class ContactUs
  def initialize(params)
    @email   = params[:email].strip   if params[:email]
    @message = params[:message].strip if params[:message]
  end

  def call
    return false unless Email.create(email: @email, message: @message).valid?

    begin
      ContactMailer.contact(@email, @message).deliver
    rescue => e
      Rails.logger.error "ContactMailer error #{e.message}"
    end

    true
  end
end
