class Api::V1::Items::SearchController < ApplicationController
  def index
    if Item.invalid_search_params?(max_price, min_price, name) # || params[:name].empty?
      return render json: { errors: 'Invalid search parameters' }, status: 400
    end

    items = Item.search_all_by_name(name) if name
    items = Item.search_all_by_price(min_price, max_price) if min_price || max_price

    render json: ItemSerializer.new(items)
  end

  private

  def max_price
    params[:max_price]
  end

  def min_price
    params[:min_price]
  end

  def name
    params[:name]
  end
end