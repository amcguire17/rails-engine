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
end
