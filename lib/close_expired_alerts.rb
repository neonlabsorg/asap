puts "Close expired alerts"
lifetimes = Lifetime.all
lifetimes.each do |lifetime|
  alerts = Alert.where(active: true, source: lifetime.source)
  next unless alerts.any?

  alerts.each do |alert|
    if alert.last_detected_at < lifetime.alert_lifetime_days.days.ago
      alert.update(active: false)
      p alert.id
      AuditLog.create(
        alert_id:            alert.id,
        event_description:  "Alert {title: #{alert.title}, asset: #{alert.asset}} has been closed due to expiration"
      )
    end
  end
end