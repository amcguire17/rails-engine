class Api::V1::ItemsController < ApplicationController
  def index
    get_page
    get_per_page
    items = Item.get_list(get_page, get_per_page)
    render json: ItemSerializer.new(items)
  end
end
