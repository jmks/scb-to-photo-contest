class ContactUs
  def initialize(params)
    @email   = params[:email].strip   if params[:email]
    @message = params[:message].strip if params[:message]
  end

  def call
    return false unless Email.create(email: @email, message: @message).valid?

    begin
      ContactMailer.contact(@email, @message).deliver
    rescue
      # log?
    end

    true
  end
end