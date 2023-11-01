class Api::V1::AlertsController < ApplicationController
  before_action :auth_from_token
  skip_before_action :verify_authenticity_token # to avoid CORS issue
  before_action :generate_uuid, only: %i[create]
  before_action :set_alert, only: %i[create]

  # POST /api/v1/alerts
  def create

    if @alert
      if @alert.active && alert_attributes[:active] == 'false'
        if @alert.update(last_closed_at: Time.now, last_closed_by: 'bot', active: false)
          render json: { data: @alert }
        else
          render json: @alert.errors, status: :unprocessable_entity
        end
      end

      if !@alert.active && alert_attributes[:active] == 'true'
        if @alert.update(alert_attributes.merge(last_detected_at: Time.now, active: true, resurfaced: true))
          render json: { data: @alert }
        else
          render json: @alert.errors, status: :unprocessable_entity
        end
      end

      if @alert.update(alert_attributes.merge(last_detected_at: Time.now, active: true))
        render json: { data: @alert }
      else
        render json: @alert.errors, status: :unprocessable_entity
      end
    else
      @alert = Alert.new(alert_attributes.merge(id: @uuid, last_detected_at: Time.now))
      if @alert.save
        render json: { data: @alert }, status: :created
      else
        render json: @alert.errors, status: :unprocessable_entity
      end
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

    all_active_alerts = Alert.where(source: params[:source], active: true).ids if params[:source].present?
    if all_active_alerts.any?
      resolved_alerts = all_active_alerts - params[:current_alerts]
      if resolved_alerts.any?
        if Alert.where(id: resolved_alerts).update_all(
          last_closed_at: Time.now, 
          last_closed_by: 'bot', 
          active: false
          )
          head :ok
        end
      end
    end

  end


  private

  def generate_uuid
    @uuid = Digest::UUID.uuid_v3(Digest::UUID::DNS_NAMESPACE, alert_attributes[:title] + alert_attributes[:asset])
  end

  def set_alert
    @alert = Alert.find_by(id: @uuid)
  end

  def alert_attributes
    params.permit(:title, :asset, :severity, :remediation, :active, :source, :issue,
                  :output, :nessus_plugin_id, :dc, cve_list: [])
  end
end