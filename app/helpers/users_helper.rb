module UsersHelper
  def gravatar_for user
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    gravatar_url = "#{Settings.user.avatar_url}/#{gravatar_id}?d=identicon"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end
