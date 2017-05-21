class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                          :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

    # :logged_in_userはメソッド名。ここでは、文字列でなく、シンボル:を与えて表記するとわかりやすい
    # edit updateのメソッドでのみ有効
    # before_action :correct_user,   only: [:edit, :update]はログイン済みが前提（順序を正しく！）
  
  def index
    # @users = User.all
    @users = User.paginate(page: params[:page])
  end
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
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
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  
  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  
  private
    def user_params #def create,edit,updateの子メソッド
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
    
    # beforeアクション
    # ログイン済みユーザーかどうか確認
    # Application Controllerに書いたので不要
    # def logged_in_user
    #   unless logged_in?
    #     store_location
    #     flash[:danger] = "Please log in."
    #     redirect_to login_url
    #     # => SessionsController#newが割り込む
    #   end
    # end
    
    # 正しいユーザーかどうか確認　（割り込み処理）
    def correct_user
      @user = User.find(params[:id])
      # redirect_to(root_url) unless @user == current_user
      redirect_to(root_url) unless current_user?(@user)
    end
    
        # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
    
end

#signupのページ
