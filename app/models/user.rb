class User < TwitterAuth::GenericUser
  # Extend and define your user model as you see fit.
  # All of the authentication logic is handled by the 
  # parent TwitterAuth::GenericUser class.
  
  def folder_name
    "#{self.twitter_id}-#{self.login}"
  end
  
end
