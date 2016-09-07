class BrandsController < ApplicationController
  def index
    # アイテムの数が多いブランド順
    brand_id_counts = Item.where.not(:brand_id => 0).group(:brand_id).order('count_brand_id desc').limit(10).count('brand_id')

    @brands = []
    Brand.where(id: brand_id_counts.keys).each do |brand|
      b = brand.attributes
      b['count'] = brand_id_counts[brand['id']]
      @brands << b
    end

  end

  def show
    brand_id = params[:id]
    @brand = Brand.find_by(id: brand_id)
    @items  = Item.where(brand_id: brand_id).order("id desc").limit(10)
    like_user_ids = LikeBrand.where(brand_id: brand_id).order("id desc").limit(100).pluck(:user_id)
    @users   = User.where(id: like_user_ids)
  end
end
