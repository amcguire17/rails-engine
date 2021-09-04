class Api::V1::MerchantsController < ApplicationController
  def index
    if params[:page] == "0"
      @page = params[:page].to_i
    else
      @page = (params.fetch(:page,1).to_i) - 1
    end
    @per_page = params.fetch(:per_page,20).to_i
    merchants = Merchant.offset(@page * @per_page).limit(@per_page)
    render json: MerchantSerializer.new(merchants)
  end
  def show
    merchant = Merchant.find(params[:id])
    render json: MerchantSerializer.new(merchant)
  end
end
