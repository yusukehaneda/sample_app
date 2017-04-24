class User < ApplicationRecord
  validates :name,  presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 }
end
# プレゼンス（存在性）がtrueであること。空白ではダメ
#　マキシマム50 最大50文字