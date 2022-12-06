class Item < ApplicationRecord
  belongs_to :merchant

  def self.search_all_by_name(keyword)
    Item.where('name ILIKE ?', "%#{keyword}%")
  end

  def self.search_all_by_price(min, max)
    items = all 
    items = items.where('unit_price >= ?', min) if min
    items = items.where('unit_price <= ?', max) if max
    items
  end
end
