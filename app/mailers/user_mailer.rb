class UserMailer < ApplicationMailer

  def account_activation(user) #アクションでなくmethodなので引数を渡せる
    @user = user
    mail to: user.email, subject: "Account activation"   #mail objectに戻り値を設定している
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset"
  end
end
