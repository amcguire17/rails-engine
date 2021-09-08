class Api::V1::ItemsController < ApplicationController
  def index
    get_page
    get_per_page
    items = Item.get_list(get_page, get_per_page)
    render json: ItemSerializer.new(items)
  end
  def show
    item = Item.find(params[:id])
    render json: ItemSerializer.new(item)
  end
  def create
    item = Item.new(item_params)
    if item.save
      render json: ItemSerializer.new(item), status: :created
    else
      render json: { error: item.errors.full_messages }, status: :unprocessable_entity
    end
  end
  def update
    item = Item.find(params[:id])
    if item.update(item_params)
      render json: ItemSerializer.new(item)
    else
      render json: { error: item.errors.full_messages }, status: :not_found
    end
  end
  def destroy
    render json: Item.delete(params[:id])
  end
  def find_one
    if params_exist(params[:name]) && (params_exist(params[:max_price]) || params_exist(params[:min_price]))
      render json: { error: 'params entered incorrectly' }, status: :bad_request
    elsif params_exist(params[:name])
      item = Item.search(params[:name])
      render json: ItemSerializer.new(item)
    elsif params_exist(params[:max_price]) && params_exist(params[:min_price])
      if params[:max_price].to_i < params[:min_price].to_i
        render json: { error: 'params entered incorrectly' }, status: :bad_request
      else
        item = Item.min_max_price(params[:min_price], params[:max_price])
        render json: ItemSerializer.new(item)
      end
    elsif params_exist(params[:max_price]) && !params_exist(params[:min_price])
      if params[:max_price].to_i < 0
        render json: { error: 'params entered incorrectly' }, status: :bad_request
      else
        item = Item.max_price(params[:max_price])
        render json: ItemSerializer.new(item)
      end
    elsif !params_exist(params[:max_price]) && params_exist(params[:min_price])
      if params[:min_price].to_i < 0
        render json: { error: 'params entered incorrectly' }, status: :bad_request
      else
        item = Item.min_price(params[:min_price])
        render json: ItemSerializer.new(item)
      end
    else
      render json: { error: 'Search not given' }, status: :bad_request
    end
  end
  def find_all
    if params_exist(params[:name])
      items = Item.search_all(params[:name])
      render json: ItemSerializer.new(items)
    else
      render json: { error: 'Search not given' }, status: :bad_request
    end
  end
  private
  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end
