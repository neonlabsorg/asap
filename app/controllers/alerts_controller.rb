class AlertsController < ApplicationController
  before_action :authorize
  before_action :set_alert, only: %i[show edit update]
  before_action :set_mode, only: %i[index]
  
  def index
    search_params = params.permit(:format, :page, q: [:title_or_asset_or_source_cont, :s, :hide_responded, :history_mode])
    # @q = Alert.where(active: true).ransack(search_params[:q])

    # Determine if the checkbox is checked
    if params[:q] && params[:q][:hide_responded] == 'true'
      # Checkbox is checked, filter for alerts with a non-empty issue field
      @q = Alert.where(active: @active, issue: ['', nil]).ransack(search_params[:q])
    else
      # Checkbox is unchecked, filter for alerts with an empty issue field
      @q = Alert.where(active: @active).ransack(search_params[:q])
    end

    alerts = @q.result.by_severity.order(created_at: :desc)
    @pagy, @alerts = pagy_countless(alerts, items: 50)
  end

  def show
  end

  def bulk_action
    @selected_alerts = Alert.where(id: params.fetch(:alert_ids, []).compact)

    if @selected_alerts.empty?
      # TODO: flash with error
      return
    end

    if params[:button] == 'close'
      @selected_alerts.update_all(active: :false, last_closed_at: Time.now, last_closed_by: current_user.displayname)
      @selected_alerts.each do |alert|
        AuditLog.create(
          alert_id: alert.id,
          event_description: "Alert {title: #{alert.title}, asset: #{alert.asset}} has been closed by #{current_user.displayname}"
        )
      end
    elsif params[:button] == 'open'
      @selected_alerts.update_all(active: :true, updated_at: Time.now)
      @selected_alerts.each do |alert|
        AuditLog.create(
          alert_id: alert.id,
          event_description: "Alert {title: #{alert.title}, asset: #{alert.asset}} has been re-opened by #{current_user.displayname}"
        )
      end
    # for other buttons, elsif should be added right here. Issue should be in the "end"
    elsif params[:button] == 'csv'
      csv = Alert.get_csv(@selected_alerts)
      send_data csv, :type => 'text/csv; charset=utf-8; header=present', :disposition => 'attachment; filename=alerts.csv'
      return
    else
      @selected_alerts.update_all(issue: params[:issue])
    end

    redirect_to action: :index
  end


  # # PATCH/PUT /alerts/1 or /alerts/1.json
  # def update
  #   # respond_to do |format|
  #   #   if @alert.update(alert_params)
  #   #     format.turbo_stream { render turbo_stream: turbo_stream.replace(@alert, partial: "alerts/alert", locals: {alert: @alert}) }
  #   #     format.html { redirect_to alert_url(@alert), notice: "Alert was successfully updated." }
  #   #     format.json { render :show, status: :ok, location: @alert }
  #   #   else
  #   #     format.html { render :edit, status: :unprocessable_entity }
  #   #     format.json { render json: @alert.errors, status: :unprocessable_entity }
  #   #   end
  #   # end
  # end


  private

  def set_alert
    @alert = Alert.find(params[:id])
  end

  def set_mode
    @active = params[:q]&.[](:history_mode) || true
  end

  def alert_params
    params.require(:alert).permit(:title, :asset)
  end

end
