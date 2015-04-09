require 'spec_helper'

describe AlertHelper, type: :helper do 

  before do
    @alert   = AlertHelper::ALERTS.sample
    @message = "#{@alert.to_s.capitalize} Will Robinson!"
  end

  describe "alerts?" do
    it "return false when no alerts are set" do 
      expect(helper.alerts?).to be false
    end

    it "returns true if flash set" do 
      flash[@alert] = @message

      expect(helper.alerts?).to be true
    end

    it "returns true if content_for set" do
      helper.content_for @alert do 
        @message
      end

      expect(helper.alerts?).to be true
    end
  end

  describe "current_alerts" do 
    it "returns the alert set by flash" do 
      flash[@alert] = @message

      expect(helper.current_alerts).to match_array [@alert]
    end

    it "returns the alert set by content_for" do 
      helper.content_for @alert do 
        @message
      end

      expect(helper.current_alerts).to match_array [@alert]
    end

    it "returns many errors set by either method" do 
      alerts = AlertHelper::ALERTS.sample(3)
      flash[alerts.first] = "#{alerts.first} notification"

      alerts[1..-1].each do |alert|
        helper.content_for(alert) { "#{alert} notification" }
      end

      expect(helper.current_alerts).to match_array alerts
    end
  end

  describe "alert_class" do 
    it "returns 'alert-success' for :notice" do 
      expect(helper.alert_class(:notice)).to eql "alert-success"
    end

    it "returns 'alert-warning' for :alert" do 
      expect(helper.alert_class(:alert)).to eql "alert-warning"
    end

    it "returns 'alert-#{name}' otherwise" do 
      expect(helper.alert_class(:info)).to eql "alert-info"
      expect(helper.alert_class(:batman)).to eql "alert-batman"
    end
  end

  describe "alert_message" do 
    it "returns the message from the flash" do 
      flash[@alert] = @message

      expect(helper.alert_message(@alert)).to eql @message
    end

    it "returns the message from content_for" do 
      helper.content_for @alert do 
        @message
      end

      expect(helper.alert_message(@alert)).to eql @message
    end

    it "returns the message from the flash before content_for" do 
      flash[@alert] = "I'm in the flash!"
      helper.content_for(@alert) { "I'm in the content_for block!" }

      expect(helper.alert_message(@alert)).to match /flash/
    end
  end
end