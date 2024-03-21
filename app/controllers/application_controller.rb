class ApplicationController < ActionController::Base
	# protect_from_forgery with: :exception
  include Pagy::Backend
	layout :layout_by_resource
  before_action :turbo_frame_request_variant

	protected

  def turbo_frame_request_variant
    request.variant = :turbo_frame if turbo_frame_request?
  end

  def current_user
    if session[:user_id] && session[:expires_at]
      if Time.now < session[:expires_at]
        @current_user ||= User.find(session[:user_id]) if session[:user_id]
      end
    end
  end

  helper_method :current_user

  def authorize
    redirect_to '/login' unless current_user
  end

	def layout_by_resource
    if controller_name == 'errors'
      'errors'
    elsif controller_name == 'sessions'
      'login'
    else
      'application'
    end
  end

  def auth_from_token
    if request.headers['X-Api-Key'].present? && request.headers['X-Api-Key'] == Rails.application.config.api_token
      true
    else
      render json: { 'code': 401, 'status': 'unauthorized' }, status: :unauthorized
    end
  end

end
