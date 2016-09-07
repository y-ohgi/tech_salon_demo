class TopController < ApplicationController
  def index
    @new_users = User.order("id desc").limit(10)
    @new_items  = Item.order("id desc").limit(10)
    @new_brands = Brand.order("id desc").limit(10)
  end
end
