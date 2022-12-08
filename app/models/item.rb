class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items

  validates_presence_of :name, :description, :unit_price
  validates_numericality_of :unit_price

  def self.search_all_by_name(keyword)
    Item.where('name ILIKE ?', "%#{keyword}%")
  end

  def self.search_all_by_price(min, max)
    items = all 
    items = items.where('unit_price >= ?', min) if min
    items = items.where('unit_price <= ?', max) if max
    items
  end

  def self.invalid_search_params?(max_price, min_price, name)
    return true if name && (max_price || min_price)

    return true if !max_price.nil? && max_price.to_i.negative?

    return true if !min_price.nil? && min_price.to_i.negative?

    return true if name.nil? && max_price.nil? && min_price.nil?

    false
    # (max_price.is_a?(Integer) && max_price.negative?) || (min_price.is_a?(Integer) && min_price.negative?)
  end
end
