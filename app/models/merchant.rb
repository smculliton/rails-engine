class Merchant < ApplicationRecord
  has_many :items

  def self.search(keyword)
    where('name ILIKE ?', "%#{keyword}%").order(:name).limit(1).take
  end
end
