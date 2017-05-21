require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")#パスワードなどの欄にはアクセスできるけど保存はされない。保存するときはハッシュ化される
  end

  test "should be valid" do
    assert @user.valid?
  end
  #validはすべて通っているか？サンプルデータが正しいかどうか？を検証すること

  test "name should be present" do
    @user.name = ""  #名前はなしはだめよ
    assert_not @user.valid?
  end
  #このユーザーはいいのか検証してね（valid）assert_notはダメであってほしいということ

  test "email should be present" do
    @user.email = "     "   #空欄はダメ
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51 #名前は何文字でもよいわけではない。51文字以内とする
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"   #255文字までとする
    assert_not @user.valid?
  end

   test "email validation should accept valid addresses" do  #正解のデータ
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    #valid_addressは成功するケースを用意しますということ。アンダーバーもハイフンも大文字もOK。＠以前でドットもOK＠以前であればプラスが使える
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
      #↑これをいれておくとどこで失敗したかがわかる
    end
  end
  
  test "email validation should reject invalid addresses" do #はじきましょうというテスト（不正解データのテスト）
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
  
  test "password should be present (nonblank)" do #パスワードが空白じゃないこと
    @user.password = @user.password_confirmation = " " * 6 #一番右の値がそれぞれの辺（passwordとpassword_confirmation）に代入される
    assert_not @user.valid?
  end


  test "password should have a minimum length" do   #パスワードを長めに設定させるため
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
  
  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end
  
  test "should follow and unfollow a user" do
    michael = users(:michael)
    archer  = users(:archer)
    assert_not michael.following?(archer)
    michael.follow(archer)
    assert michael.following?(archer)
    assert archer.followers.include?(michael)
    michael.unfollow(archer)
    assert_not michael.following?(archer)
  end
end