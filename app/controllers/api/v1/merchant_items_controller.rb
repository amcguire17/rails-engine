class Api::V1::MerchantItemsController < ApplicationController
  def index
    items = Merchant.find(params[:id]).items
    render json: ItemSerializer.new(items)
  end
end
