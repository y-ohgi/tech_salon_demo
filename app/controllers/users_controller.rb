class UsersController < ApplicationController

  def index
    # 最近LIKEしたユーザー一覧
    recent_like_user_ids = LikeItem.distinct("user_id").order("id desc").limit(100).pluck(:user_id)
    @users = User.where(id: recent_like_user_ids)

  end

  def show
    user_id = params[:id]
    @user = User.find_by(id: user_id)
    like_item_ids  = LikeItem.where(user_id: user_id).order("id desc").limit(100).pluck(:item_id)
    @like_items  = Item.where(id: like_item_ids)
    like_brand_ids = LikeBrand.where(user_id: user_id).order("id desc").pluck(:brand_id)
    @like_brands = Brand.where(id: like_brand_ids)
  end
end
