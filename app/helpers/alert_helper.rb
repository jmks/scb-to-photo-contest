module AlertHelper
  ALERTS = [ :notice, :info, :alert, :danger ]

  def alerts?
    current_alerts.any?
  end

  def current_alerts
    ALERTS.select { |a| flash[a] || content_for?(a) }
  end

  def alert_class alert
    case alert
    when :notice then "success"
    when :alert  then "warning"
    else alert.to_s
    end.prepend "alert-"
  end

  def alert_message alert
    flash[alert] || content_for(alert)
  end
end