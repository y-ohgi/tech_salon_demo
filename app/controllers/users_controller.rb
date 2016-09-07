class UsersController < ApplicationController
  def show
    user_id = params[:id]
    @user = User.find_by(user_id)
    @like_items  = @user.like_items.order("id desc").limit(100)
    @like_brands = @user.like_brands.joins({:brand => {:brand_id => :brand_id})
  end
end
