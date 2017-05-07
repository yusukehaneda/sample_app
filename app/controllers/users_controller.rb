class UsersController < ApplicationController

  def show
    @user = User.find(params[:id]) 
  end

#def showはshouwアクションのこと。これは　app/views/users/show.html.erbを呼び出す
#URLのidと同じデータを引っ張る（user/2というURLにしたらid=2のユーザを引っ張る）
# 例えばUser.firstとやるとユーザid=1の人が出てくる
# user = User.firstというふうにすると、このdef showアクション以外では使用できないので、@user = User.～としている
# debugger

  def new
    @user = User.new #空のインスタンスをまず作成し、インスタンス変数@userに代入
  end
  
  def create
    @user = User.new(user_params) 
    #この下にuser_paramsというメソッドを作る↓↓
    #こうするとすべてのuser属性が当てはまっていく。一行で済む
    # @user = User.new(params[:user])とするとadminとかで登録できてしまう。マスアサイメント脆弱性
    if @user.save
      #success
      log_in @user
      flash[:success] = "Welcome to the Sample App!" #flashというメソッド（変数）は一度だけ出して、二度目は消す
        redirect_to @user
        #userのプロフィールページに飛ぶ redirect_to user_path(@user.id)の省略形
        #GET / users/:idという処理が行われる
    else
      render 'new'
      #failure
      #newテンプレートをレンダリングする（上のdef newメソッドのアクションを行う）。つまり、その中身が何であれ、signアップフォームに戻す
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
      # 更新に成功した場合を扱う。
    else
      render 'edit'
    #editテンプレートをレンダリングする（上のdef editメソッドのアクションを行う）。
    end
  end

  
  private
    def user_params #def create,edit,updateの子メソッド
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end

#signupのページ
