class AddIndexToUsersEmail < ActiveRecord::Migration[5.0]
  def change
    add_index :users, :email, unique: true
  end
end
# add_index :users, :email, unique: true　ユーザーズというテーブルのemailのカラムがユニークになるようにしてね
# Railsのモデルのuser.rbで防げないのでDB側で防いでね