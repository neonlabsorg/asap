class LifetimesController < ApplicationController
  before_action :authorize
  before_action :set_lifetime, only: %i[destroy]
  
  def index
    @lifetimes = Lifetime.all
  end

  def new
    @lifetime = Lifetime.new
  end

  def create
    @lifetime = Lifetime.new(lifetime_params)
    if @lifetime.save
      flash[:success] = "Created"
      redirect_to lifetimes_path
    else
      flash[:errors] = @lifetime.errors.full_messages
      redirect_to lifetimes_path
    end
  end

  def destroy
    if @lifetime.destroy
      flash[:success] = "Deleted"
      redirect_back(fallback_location: lifetimes_path)
    else
      flash[:errors] = @lifetime.errors.full_messages
      redirect_back(fallback_location: lifetimes_path)
    end
  end

  private

  def set_lifetime
    @lifetime = Lifetime.find(params[:id])
  end

  def lifetime_params
    params.require(:lifetime).permit(:source, :alert_lifetime_days)
  end

end
