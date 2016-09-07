class Item < ApplicationRecord

  @@cache = RedisCache.new(self.table_name.to_sym)

  def self.get_item(item_id)
    item = @@cache.get(item_id)
    if !item.nil?
      return item
    end
    item = Item.find_by(id: item_id)
    @@cache.set(item_id, item)
    item
  end

  def self.get_items(item_ids = [])
    items = @@cache.bulk_get(item_ids)
    item_ids.each_with_index do |id, idx|
      if items[idx].nil?
        items[idx] = self.get_item(id)
      end
    end
    items
  end

end
