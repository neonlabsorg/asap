class Api::V1::AlertsController < ApplicationController
  before_action :auth_from_token
  skip_before_action :verify_authenticity_token
  before_action :generate_uuid, only: [:create]
  before_action :set_alert, only: [:create]

  # POST /api/v1/alerts
  def create
    if @alert
      handle_alert
    else
      create_alert
    end
  end

  # POST /api/v1/arrange_alerts
  def arrange_alerts
    # Close all outdated or resolved alerts assotiated to watcher 
    # Expect json containing watcher name and currently active alerts IDs.
    # {
    #   source: "dummy-watcher",
    #   current_alerts: [ "id-1", "id-2", "id-n" ]
    # }
    close_resolved_alerts
  end

  private

  def generate_uuid
    @uuid = Digest::UUID.uuid_v3(Digest::UUID::DNS_NAMESPACE, alert_params[:title] + alert_params[:asset])
  end

  def set_alert
    @alert = Alert.find_by(id: @uuid)
  end

  def alert_params
    params.permit(:title, :asset, :severity, :remediation, :active, :source, :issue,
                  :output, :nessus_plugin_id, :dc, cve_list: [])
  end

  def handle_alert
    if @alert.active && alert_params[:active] == 'false'
      close_alert
      AuditLog.create(
        alert_id: @alert.id,
        event_description: "Alert {title: #{@alert.title}, asset: #{@alert.asset}} has been closed by #{@alert.source}"
      )
    elsif !@alert.active && alert_params[:active] == 'true'
      reopen_alert
      AuditLog.create(
        alert_id: @alert.id,
        event_description: "Alert {title: #{@alert.title}, asset: #{@alert.asset}} has been re-opened by #{@alert.source}"
      )
    else
      update_alert
    end
  end

  def close_alert
    update_alert_attributes(last_closed_at: Time.now, last_closed_by: 'bot', active: false)
  end

  def reopen_alert
    update_alert_attributes(alert_params.merge(last_detected_at: Time.now, active: true, resurfaced: true))
  end

  def update_alert
    update_alert_attributes(alert_params.merge(last_detected_at: Time.now, active: true))
  end

  def update_alert_attributes(attributes)
    if @alert.update(attributes)
      render json: { data: @alert }
    else
      render json: @alert.errors, status: :unprocessable_entity
    end
  end

  def create_alert
    @alert = Alert.new(alert_params.merge(id: @uuid, last_detected_at: Time.now))
    if @alert.save
      AuditLog.create(
        alert_id: @alert.id,
        event_description: "Alert {title: #{@alert.title}, asset: #{@alert.asset}} has been created by #{@alert.source}"
      )
      render json: { data: @alert }, status: :created
    else
      render json: @alert.errors, status: :unprocessable_entity
    end
  end

  def close_resolved_alerts
    return unless params[:source].present?

    all_active_alerts = Alert.where(source: params[:source], active: true).ids
    resolved_alerts = all_active_alerts - params[:current_alerts]

    return unless resolved_alerts.any?

    resolved_alerts.each do |alert|
      AuditLog.create(
        alert_id: alert.id,
        event_description: "Alert {title: #{alert.title}, asset: #{alert.asset}} has been closed by #{alert.source}"
      )
    end

    if Alert.where(id: resolved_alerts).update_all(
         last_closed_at: Time.now,
         last_closed_by: 'bot',
         active: false
       )
      head :ok
    end
  end
end
