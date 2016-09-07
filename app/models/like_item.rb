class LikeItem < ApplicationRecord
  belongs_to :users, foreign_key: 'user_id'
  belongs_to :items, foreign_key: 'item_id'
end
