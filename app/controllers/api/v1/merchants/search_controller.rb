class Api::V1::Merchants::SearchController < ApplicationController
  def show 
    merchant = Merchant.search(params[:name]) || Merchant.new

    render json: MerchantSerializer.new(merchant)
  end
end