class User < ApplicationRecord
  has_many :like_items,  foreign_key: 'user_id'
  has_many :like_brands, foreign_key: 'user_id'

  @@cache = RedisCache.new(self.table_name.to_sym)

  def self.get_user(user_id)
    user = @@cache.get(user_id)
    if !user.nil?
      return user
    end
    user = User.find_by(id: user_id)
    @@cache.set(user_id, user)
    user
  end

  def self.get_users(user_ids = [])
    users = @@cache.bulk_get(user_ids)
    user_ids.each_with_index do |id, idx|
      if users[idx].nil?
        users[idx] = self.get_user(id)
      end
    end
    users
  end
end
