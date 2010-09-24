module Twitter
  module Adapter
  
    def friendship_exists? login
      lm_username = Twitter::Loader.config[:username]
      Twitter::Loader.instance.friendship_exists?(login, lm_username) ? true : false
    end
  
  end
end