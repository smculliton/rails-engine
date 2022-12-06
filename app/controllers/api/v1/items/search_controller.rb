class Api::V1::Items::SearchController < ApplicationController
  def index
    items = Item.search_all_by_name(params[:name]) if params[:name]
    items = Item.search_all_by_price(params[:min_price], params[:max_price]) if params[:min_price] || params[:max_price]
    
    render json: ItemSerializer.new(items)
  end
end