class IpAddressesController < ApplicationController
  before_action :authorize

  def index
    # For non-admin the audit logs are restricted to permitted systems
    search_params = params.permit(:format, :page, q: [:ip_cont, :s])
    @q = IpAddress.all.order(created_at: :desc).ransack(search_params[:q])
    ip_addresses = @q.result
    @pagy, @ip_addresses = pagy_countless(ip_addresses, items: 50)
  end
end 


