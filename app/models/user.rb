class User < ApplicationRecord
  has_many :like_items,  foreign_key: 'user_id'
  has_many :like_brands, foreign_key: 'user_id'
end
