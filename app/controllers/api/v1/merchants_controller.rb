class Api::V1::MerchantsController < ApplicationController
  def index
    merchants = Merchant.all
    render json: MerchantSerializer.new(merchants)
  end

  def show
    merchant = Merchant.find_by(id: params[:id])
    return render json: { error: 'Merchant id not found' }, status: 404 if merchant.nil?
    
    render json: MerchantSerializer.new(merchant)
  end
end