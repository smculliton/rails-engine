class Api::V1::Merchants::ItemsController < ApplicationController
  def index
    merchant = Merchant.find_by(id: params[:merchant_id])
    return render json: { errors: 'Merchant id not found' }, status: 404 if merchant.nil?
    
    render json: ItemSerializer.new(merchant.items)
  end 
end