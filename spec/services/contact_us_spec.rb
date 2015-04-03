require "spec_helper"

describe ContactUs do

  context "when invalid input" do 
    it "returns false for blank email" do 
      expect(ContactUs.new({ message: "Yo dawg" }).call).to be false
    end

    it "returns false for blank messages" do 
      expect(ContactUs.new({ email: "xibit@example.com" }).call).to be false
    end

    it "returns false for invalid emails" do 
      expect(ContactUs.new({ email: "xibit@example", message: "Yo dawg" }).call).to be false
    end

    it "does not create Email in database" do 
      expect {
        ContactUs.new({ email: "xibit@example", message: "" }).call
      }.to_not change {
        Email.count
      }
    end

    it "does not send an email" do 
      expect {
        ContactUs.new({ email: "xibit@example", message: "" }).call
      }.to_not change {
        ActionMailer::Base.deliveries.length
      }
    end
  end

  it "creates an Email with valid input" do 
    expect {
      ContactUs.new({ email: "xibit@example.com", message: "Yo dawg" }).call
    }.to change {
      Email.count
    }.by(1)
  end

  it "sends an email with valid input" do 
    expect {
      ContactUs.new({ email: "xibit@example.com", message: "Yo dawg" }).call
    }.to change {
      ActionMailer::Base.deliveries.length
    }.by(1)
  end
end