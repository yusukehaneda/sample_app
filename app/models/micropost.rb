class Micropost < ApplicationRecord
  belongs_to :user
  # -> @micropost.user.name
  default_scope -> { order(created_at: :desc) }#降順に並べる
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate  :picture_size

  private

    # アップロードされた画像のサイズをバリデーションする
    def picture_size
      if picture.size > 3.megabytes
        errors.add(:picture, "should be less than 3MB")
      end
    end
end
