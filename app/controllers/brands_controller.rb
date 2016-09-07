class BrandsController < ApplicationController
  def index
    # アイテムの数が多いブランド順
    @brands = Brand.ranking
  end

  def show
    brand_id = params[:id]
    @brand = Brand.find_by(id: brand_id)
    @items  = Item.where(brand_id: brand_id).limit(100)
    like_user_ids = LikeBrand.where(brand_id: brand_id).limit(100).pluck(:user_id)
    @users   = User.where(id: like_user_ids)
  end
end
