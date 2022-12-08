class Api::V1::ItemsController < ApplicationController
  after_action :destroy_empty_invoices, only: :destroy

  def index 
    items = Item.all
    render json: ItemSerializer.new(items)
  end

  def show 
    item = Item.find_by(id: params[:id])
    return render json: { error: 'Item id not found' }, status: 404 if item.nil?

    render json: ItemSerializer.new(item)
  end

  def create
    item = Item.new(item_params)
    if item.save
      render json: ItemSerializer.new(item), status: :created
    else
      render json: { error: 'Invalid item params' }, status: 404
    end
  end

  def update
    item = Item.find(params[:id])
    if item.update(item_params)
      render json: ItemSerializer.new(item)
    else
      render json: { error: 'Invalid item params' }, status: 404
    end
  end

  def destroy
    item = Item.find_by(id: params[:id])
    return render json: { error: 'Item id not found' }, status: 404 if item.nil?

    item.destroy
  end

  private

  def destroy_empty_invoices
    Invoice.all.each do |invoice|
      invoice.destroy if invoice.invoice_items.empty?
    end
  end

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end