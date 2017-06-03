class UserMailer < ApplicationMailer

  def account_activation(user) #アクションでなくmethodなので引数を渡せる
    @user = user
    mail to: user.email, subject: "Account activation"   #mail objectに戻り値を設定している
  end

  def password_reset
    @greeting = "Hi"
    mail to: "to@example.org"
  end
end
