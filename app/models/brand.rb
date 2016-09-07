class Brand < ApplicationRecord
  has_many :like_brands, foreign_key: 'brand_id'
end
