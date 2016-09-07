class LikeBrand < ApplicationRecord
  belongs_to :brands, foreign_key: 'brand_id'
  belongs_to :users,  foreign_key: 'user_id'
end
