class User < ApplicationRecord
  before_save { self.email = self.email.downcase }
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
end


#アプリケーションレコードを継承しているUserクラス。ただのUserクラスではない
#validatesはvalidationを走らせること
#before_save { self.email = email.downcase }セーブをする直前に{}のなかの処理を実行してください
# self.email.downcaseメールアドレスをすべて小文字にする もし大文字で入ってしまっても、小文字に変換するから強制的にユニークになるよ
# プレゼンス（存在性）がtrueであること。空白・0文字ではダメ
#　VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i　は正規表現にのっとっているかを確認するコード
# VALID_EMAIL_REGEXが大文字なのは定数（あまりかえたくない）ので
#　マキシマム50 最大50文字 nameは50文字以内 emailは255文字以内
# format: { with: VALID_EMAIL_REGEX }オプション上のVALID_EMAIL_REGEXを指定している
#case_sensitive 小文字と大文字を区別しない
