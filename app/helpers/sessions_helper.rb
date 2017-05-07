module SessionsHelper
  
    # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end
  
    # 現在ログイン中のユーザーを返す (いる場合)
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
    # @current_user = @current_user || User.find_by(id: session[:user_id])の短縮形
    # @current_userがnil もしくはfalseなら、User.find_byを実行する。実行したら@current_userに代入する
    # @current_userが存在すれば、User.find_byは実行されない。すなわち、初めは必ずnilなので、2回目以降は検索を行わない
  end
  
    # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in? #true/falseで返す
    !current_user.nil?
  end
  
    # 現在のユーザーをログアウトする
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
  
end



#モジュールはクラスや定数などが詰まっているパッケージ