module Util
  S3_PATH = "https://img.iqon.jp/items/"

  def self.image_url(item_id)
    "#{self::S3_PATH}/#{item_id}/#{item_id}_l.jpg"
  end
end
