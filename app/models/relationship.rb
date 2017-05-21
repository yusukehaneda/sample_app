class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User" #follower_idが呼ばれるがfollowerクラスはないのでUserクラスが呼ばれる
  belongs_to :followed, class_name: "User"
  # belongs_to :user => "#{table}_id"としてしまうとRelationshipカラムからUserを探してしまう。無駄になってしまう。
  # Relationship.first.follower => @user
  # Relationship.first.followed => @user  
  validates :follower_id, presence: true
  validates :followed_id, presence: true
end