class SessionsController < ApplicationController
  def new
  end

  # ログイン画面にはメールアドレスをパスワードしか入れないので、そこからユーザを紐づけて引っ張る
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
    # if user.nil? && user.authenticate(params[:session][:password])と同じ意味
      #success
      log_in user
      #9章 params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_back_or user
    else
      #false
      flash.now[:danger] = 'Invalid email/password combination' # 本当は正しくない
      render 'new'    #sessions_controller内のnew actionに対応するnewテンプレートが呼び出される
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
  
end
