class Api::V1::RevenueController < ApplicationController
  def quantity_merchants
    if params[:quantity]
      merchants = Merchant.quantity_by_revenue(params[:quantity])
      render json: MerchantNameRevenueSerializer.new(merchants)
    else
      render_no_params
    end
  end
end
