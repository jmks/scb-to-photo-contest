class ContactUs
  def initialize(params)
    @email   = params[:email].strip   if params[:email]
    @message = params[:message].strip if params[:message]
  end

  def call
    return false unless valid?

    begin
      Email.create(email: @email, message: @message)
      ContactMailer.contact(@email, @message).deliver
    rescue
      # log?
    end

    true
  end

  private

  def valid?
    Email.new(email: @email, message: @message).valid?
  end
end