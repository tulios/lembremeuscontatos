class HomeController < ApplicationController

  def index
    redirect_to :controller => "users/dashboard" if logged_in?
  end

end

