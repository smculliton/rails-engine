class Api::V1::Merchants::SearchController < ApplicationController
  def show 
    return render json: { errors: 'No search params given' }, status: 400 if params[:name].nil? || params[:name].empty?
    
    merchant = Merchant.search(params[:name]) || Merchant.new

    render json: MerchantSerializer.new(merchant)
  end
end