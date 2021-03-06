class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save   :downcase_email
  before_create :create_activation_digest
  
  has_many :microposts, dependent: :destroy  #userとmicropostとの関連付け
  has_many :active_relationships,   class_name: "Relationship",
                                    foreign_key: "follower_id",
                                    dependent:   :destroy 
                                    #ユーザが消えたらrelationshipも消えるようにする（相手方のフォロワー数が減る
  
  # =>ActiveRelationshipというテーブルがあるのか勘違いしないようにクラスを定義する
  # User_idを探しに行かないようにforeign_keyを設定する
  
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :following, through: :active_relationships,  source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
    
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
  
    # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
    # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end

  
  def feed
    # Micropost.where("user_id = ?", self.following_ids,self.id)
    # Micropost.where("user_id IN (:following_ids) OR user_id = :user_id",
    # following_ids: self.following_ids, user_id: self.id)

    following_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: self.id)
  end
  
    # アカウントを有効にする
  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # 有効化用のメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

    # パスワード再設定の属性を設定する
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # パスワード再設定のメールを送信する

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end
  
  #2時間前より早い。例えば1時間前とか30分前
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end
  
    # ユーザーをフォローする
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # ユーザーをフォロー解除する
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # 現在のユーザーがフォローしてたらtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end
  
  private

    # メールアドレスをすべて小文字にする
    def downcase_email
      self.email = email.downcase
    end

    # 有効化トークンとダイジェストを作成および代入する
    #このケースでは、ユーザーをcreateする前に実行する
    def create_activation_digest
      self.activation_token  = User.new_token #鍵を生成して、一時的にactivation_tokenに保存
      self.activation_digest = User.digest(activation_token) #digestクラスメソッドを使って、ハッシュ化したものをDBのactivation_digestカラムに入れる
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