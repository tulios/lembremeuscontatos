class HomeController < ApplicationController
  
  def index
    
    if logged_in?
      redirect_to :controller => "users/dashboard"
      return
    end
    
  end
  
end