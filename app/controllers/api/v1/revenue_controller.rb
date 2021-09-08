class Api::V1::RevenueController < ApplicationController
  def quantity_merchants
    if params[:quantity]
      merchants = Merchant.quantity_by_revenue(params[:quantity])
      render json: MerchantNameRevenueSerializer.new(merchants)
    else
      render_no_params
    end
  end
  def revenue_merchant
    merchant = Merchant.find(params[:id])
    revenue = Merchant.total_revenue(merchant.id)
    render json: MerchantRevenueSerializer.new(revenue)
  end
  def revenue_date
    id = nil
    if params_exist(params[:start_date]) && params_exist(params[:end_date])
      params[:end_date] = params[:end_date].to_date.end_of_day.to_s
      if params[:start_date] < params[:end_date]
        revenue = Invoice.revenue_by_date(params[:start_date], params[:end_date])
        render json: RevenueDateSerializer.format_revenue(id, revenue)
      else
        render json: { error: 'Start date cannot be greater than end date' }, status: :bad_request
      end
    elsif params_exist(params[:start]) && params_exist(params[:end])
      params[:end] = params[:end].to_date.end_of_day.to_s
      if params[:start] < params[:end]
        revenue = Invoice.revenue_by_date(params[:start], params[:end])
        render json: RevenueDateSerializer.format_revenue(id, revenue)
      else
        render json: { error: 'Start date cannot be greater than end date' }, status: :bad_request
      end
    else
      render_no_params
    end
  end
  def quantity_items
    if params_exist(params[:quantity])
      if params[:quantity].to_i > 0
        items = Item.quantity_by_revenue(params[:quantity].to_i)
        render json: ItemRevenueSerializer.new(items)
      else
        render json: { error: 'param entered incorreclty'}, status: :bad_request
      end
    else
      render_no_params
    end
  end
end
