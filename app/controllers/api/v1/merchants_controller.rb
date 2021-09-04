class Api::V1::MerchantsController < ApplicationController
  def index
    get_page
    get_per_page
    merchants = Merchant.get_list(get_page, get_per_page)
    render json: MerchantSerializer.new(merchants)
  end
  def show
    merchant = Merchant.find(params[:id])
    render json: MerchantSerializer.new(merchant)
  end
end
