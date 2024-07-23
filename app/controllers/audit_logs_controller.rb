class AuditLogsController < ApplicationController
  before_action :authorize

  def index
    # For non-admin the audit logs are restricted to permitted systems
    search_params = params.permit(:format, :page, q: [:event_description_cont, :s])
    @q = AuditLog.all.order(created_at: :desc).ransack(search_params[:q])
    audit_logs = @q.result
    @pagy, @audit_logs = pagy_countless(audit_logs, items: 50)
  end

end

