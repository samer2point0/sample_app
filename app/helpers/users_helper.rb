module UsersHelper
  def gravatar_for(user, options={size:50})
    gravatar_id=Digest::MD5::hexdigest(user.email.downcase)
    size=options[:size]
    gravatar_url="https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag gravatar_url , {alt: user.name, class: "gravatar"}
  end
  def store_location
    session[:forwarding_url]=request.original_url if request.get?
  end
end
