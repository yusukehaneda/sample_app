class UsersController < ApplicationController

  def show
    @user = User.find(params[:id]) #URLのidと同じデータを引っ張る（user/2というURLにしたらid=2のユーザを引っ張る）
    # debugger
  end
#showアクションは　app/views/users/show.html.erbを呼び出す

  def new
    @user = User.new #空のインスタンスをまず作成する
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      #success
        flash[:success] = "Welcome to the Sample App!"
        redirect_to @user
    else
      #failure
    render 'new'
    end
  end
  
  def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
  end
end

#signupのページ
