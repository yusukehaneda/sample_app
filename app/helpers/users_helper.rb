module UsersHelper

  # 引数で与えられたユーザーのGravatar画像を返す 引数にuserと書いてある
  def gravatar_for(user)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase) #メールアドレスを散らしたもの
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar") #ソースはグラバターの画像 htmlのクラスをgravaterとしている
  end
end