class Api::V1::ItemMerchantController < ApplicationController
  def show
    merchant = Item.find(params[:id]).merchant
    render json: MerchantSerializer.new(merchant)
  end
end
