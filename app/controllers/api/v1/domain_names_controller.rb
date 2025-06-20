class Api::V1::DomainNamesController < ApplicationController
  before_action :auth_from_token
  skip_before_action :verify_authenticity_token
  before_action :set_domain_name, only: [:update, :destroy]

  def index
    @domain_names = DomainName.all
    render json: @domain_names
  end

  def create
    @domain_name = DomainName.new(domain_name_params)

    if @domain_name.save
      render json: @domain_name, status: :created
    else
      render json: @domain_name.errors, status: :unprocessable_entity
    end
  end

  def update
    if @domain_name.update(domain_name_params)
      render json: @domain_name
    else
      render json: @domain_name.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @domain_name.destroy
    head :no_content
  end

  private

  def set_domain_name
    @domain_name = DomainName.find(params[:id])
  end

  def domain_name_params
    params.require(:domain_name).permit(:domain)
  end
end 