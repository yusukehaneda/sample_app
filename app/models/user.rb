class User < ApplicationRecord
  has_many :microposts, dependent: :destroy  #userとmicropostとの関連付け
  before_save { self.email = self.email.downcase }
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, 
                        length: { minimum: 6 },
                        allow_nil:true
                        
    # 渡された文字列のハッシュ値を返す 三項演算子
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  # 試作feedの定義
  # 完全な実装は次章の「ユーザーをフォローする」を参照
  def feed
    Micropost.where("user_id = ?", id)
  end

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
# has_secure_passwordがパスワードダイジェストに保存してくれる
#パスワードを6文字以上にする
#allow_nil:trueはパスワードのエラーが二回出てしまう時の回避対応