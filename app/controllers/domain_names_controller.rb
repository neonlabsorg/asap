class DomainNamesController < ApplicationController
  before_action :authorize

  def index
    # For non-admin the audit logs are restricted to permitted systems
    search_params = params.permit(:format, :page, q: [:domain_cont, :s])
    @q = DomainName.all.order(created_at: :desc).ransack(search_params[:q])
    domain_names = @q.result
    @pagy, @domain_names = pagy_countless(domain_names, items: 50)
  end

end