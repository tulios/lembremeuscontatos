class Users::MainController < ApplicationController
  
  before_filter :login_required
  
end