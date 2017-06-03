class SessionsController < ApplicationController
  def new
  end

  # ログイン画面にはメールアドレスをパスワードしか入れないので、そこからユーザを紐づけて引っ張る
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
    # ここではuserはローカル変数を使う。if !user.nil? && user.authenticate(params[:session][:password])と同じ意味
      #success
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end    
    else
      #false
      flash.now[:danger] = 'Invalid email/password combination' # 本当は正しくない
      render 'new'    #sessions_controller内のnew action（def new）に対応するnewテンプレートが呼び出される(new.htmlにとぶ)
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
  
end
