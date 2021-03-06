class ItemsController < ApplicationController

  def index
    # 最もお気に入りが多いアイテムランキング
    item_id_counts = LikeItem.group(:item_id).order('count_item_id desc').limit(100).count('item_id')

    @items = []
    Item.where(id: item_id_counts.keys).each do |item|
      i = item.attributes
      i['count'] = item_id_counts[item['id']]
      @items << i
    end
    @items = @items.sort_by {|k| -k["count"]}
  end

  def show
    item_id = params[:id]
    @item = Item.find_by(id: item_id)
    like_user_ids = LikeItem.where(item_id: item_id).limit(100).pluck(:user_id)
    @users = User.where(id: like_user_ids)
    item_ids = Item.where(brand_id: @item['brand_id']).limit(100).pluck(:id)
    @items = Item.where(id: item_ids)
  end
end
