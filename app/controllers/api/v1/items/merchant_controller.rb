class Api::V1::Items::MerchantController < ApplicationController
  def index
    item = Item.find_by(id: params[:item_id])
    return render json: { errors: 'Item id not found' }, status: 404 if item.nil?

    render json: MerchantSerializer.new(item.merchant)
  end
end