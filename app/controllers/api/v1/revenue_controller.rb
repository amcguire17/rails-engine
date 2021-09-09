class Api::V1::RevenueController < ApplicationController
  def quantity_merchants
    if params[:quantity]
      merchants = Merchant.quantity_by_revenue(params[:quantity])
      render json: MerchantNameRevenueSerializer.new(merchants)
    else
      render_bad_request('param not given')
    end
  end

  def revenue_merchant
    merchant = Merchant.find(params[:id])
    revenue = Merchant.total_revenue(merchant.id)
    render json: MerchantRevenueSerializer.new(revenue)
  end

  def revenue_date
    if params_exist(params[:start]) && params_exist(params[:end])
      params[:end] = params[:end].to_date.end_of_day.to_s
      id = nil
      if params[:start] < params[:end]
        revenue = Invoice.revenue_by_date(params[:start], params[:end])
        render json: RevenueDateSerializer.format_revenue(id, revenue)
      else
        render_bad_request('Start date cannot be greater than end date')
      end
    else
      render_bad_request('param not given')
    end
  end

  def quantity_items
    quantity = params.fetch(:quantity, 10).to_i
    if quantity != 0
      items = Item.quantity_by_revenue(quantity)
      render json: ItemRevenueSerializer.new(items)
    else
      render_bad_request('param entered incorrectly')
    end
  end

  def unshipped
    quantity = params.fetch(:quantity, 10).to_i
    if quantity != 0
      invoices = Invoice.potential_revenue(quantity)
      render json: UnshippedOrderSerializer.new(invoices)
    else
      render_bad_request('param entered incorrectly')
    end
  end

  def weekly
    id = nil
    revenue = Invoice.revenue_by_week
    render json: WeeklyRevenueSerializer.format_data(id, revenue)
  end
end
