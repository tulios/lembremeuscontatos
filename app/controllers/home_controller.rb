class HomeController < ApplicationController

  def index
    redirect_to :controller => "users/dashboard", :login => current_user.login if logged_in?
  end

end

