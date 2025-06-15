class Api::V1::IpAddressesController < ApplicationController
  before_action :auth_from_token
  skip_before_action :verify_authenticity_token
  before_action :set_ip_address, only: [:update, :destroy]

  def index
    @ip_addresses = IpAddress.all
    render json: @ip_addresses
  end

  def create
    @ip_address = IpAddress.new(ip_address_params)

    if @ip_address.save
      render json: @ip_address, status: :created
    else
      render json: @ip_address.errors, status: :unprocessable_entity
    end
  end

  def update
    if @ip_address.update(ip_address_params)
      render json: @ip_address
    else
      render json: @ip_address.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @ip_address.destroy
    head :no_content
  end

  private

  def set_ip_address
    @ip_address = IpAddress.find(params[:id])
  end

  def ip_address_params
    params.require(:ip_address).permit(:ip, :description)
  end
end