class UsersController < ApplicationController

  def show
    @user = User.find(params[:id]) #URLのidと同じデータを引っ張る（user/2というURLにしたらid=2のユーザを引っ張る）
    # debugger
  end
#showアクションは　app/views/users/show.html.erbを呼び出す

  def new
  end
  
end

#signupのページ
