# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  # Scrub sensitive parameters from your log
  filter_parameter_logging :password
  
  include LembreMeusContatos::RescueFrom
  rescue_from StandardError, :with => :tratar_standard_error
  rescue_from LembreMeusContatos::Exceptions::BadBehavior, :with => :tratar_bad_behavior
  rescue_from CanCan::AccessDenied, :with => :tratar_cancan_error
     
  protected
  
  def authentication_succeeded message = nil#t("app.login_sucesso")
    super
  end
  
  def authentication_failed message = t("app.login_erro")
    super
  end
  
end
