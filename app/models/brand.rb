class Brand < ApplicationRecord
  has_many :like_brands, foreign_key: 'brand_id'

  @@cache = RedisCache.new(self.table_name.to_sym)

  # アイテムの数が多いブランド順
  def self.ranking
    @brands = []
    cache = @@cache.zrevrange('ranking', 0, 100)
    if cache.present?
      cache.each do |brand|
        b = Brand.get_brand(brand[0]).attributes
        b['count'] = brand[1].to_i
        @brands << b
      end
    else
      brand_id_counts = Item.where.not(:brand_id => 0).group(:brand_id).order('count_brand_id desc').limit(100).count('brand_id')

      Brand.where(id: brand_id_counts.keys).each do |brand|
        @@cache.zadd('ranking', brand_id_counts[brand['id']], brand['id'])
        b = brand.attributes
        b['count'] = brand_id_counts[brand['id']]
        @brands << b
      end
      @brands = @brands.sort_by {|b| -b['count']}
    end
    @brands
  end

  def self.get_brand(brand_id)
    brand = @@cache.get(brand_id)
    if !brand.nil?
      return brand
    end
    brand = Brand.find_by(id: brand_id)
    @@cache.set(brand_id, brand)
    brand
  end

  def self.get_brands(brand_ids = [])
    brands = @@cache.bulk_get(brand_ids)
    brand_ids.each_with_index do |id, idx|
      if brands[idx].nil?
        brands[idx] = self.get_brand(id)
      end
    end
    brands
  end


end
