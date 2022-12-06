class Api::V1::Merchants::SearchController < ApplicationController
  # is there a better way to handle this sad path?
  def show 
    merchant = Merchant.search(params[:name]) || Merchant.new
    # return render json: {data: {} } if merchant.nil?

    render json: MerchantSerializer.new(merchant)
  end
end