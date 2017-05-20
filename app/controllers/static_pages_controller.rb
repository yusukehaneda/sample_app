class StaticPagesController < ApplicationController
  def home
    # => app/views/コントローラ名/アクション名.html.erb がデフォルト
    if logged_in?
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
    # ログインしてたら実行
  end

  def help
  end
  
  def about
  end
  
  def contact
  end

end
