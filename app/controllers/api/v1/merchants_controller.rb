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

  def find_one
    if params_exist(params[:name])
      merchant = Merchant.search(params[:name])
      render json: (merchant ? MerchantSerializer.new(merchant) : { data: {} })
    else
      render_bad_request('param not given')
    end
  end

  def find_all
    if params_exist(params[:name])
      merchants = Merchant.search_all(params[:name])
      render json: MerchantSerializer.new(merchants)
    else
      render_bad_request('Search not given')
    end
  end

  def quantity_items
    if params[:quantity]
      merchants = Merchant.quantity_by_items(params[:quantity])
      render json: ItemsSoldSerializer.new(merchants)
    else
      render_bad_request('param not given')
    end
  end
end
