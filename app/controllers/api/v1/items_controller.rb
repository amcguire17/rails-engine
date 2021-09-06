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
  def find_all
    if !params[:name].nil? && !params[:name].empty?
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
