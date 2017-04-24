require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Example User", email: "user@example.com")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = ""  
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "     "   #空欄はダメ
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

   test "email validation should accept valid addresses" do
     #正解のデータ
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
                        #アンダーバーもハイフンも大文字もOK＠以前でドットもOK＠以前であればプラスが使える
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
      #↑これをいれておくとどこで失敗したかがわかる
    end
  end
  
  test "email validation should reject invalid addresses" do #はじきましょうというテスト
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
                               #ピリオドの代わりにカンマになっている　＠のあとアンダーバーはダメとか
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end
  
  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase  #upcaseは小文字を大文字にする
    @user.save
    assert_not duplicate_user.valid?
  end
end