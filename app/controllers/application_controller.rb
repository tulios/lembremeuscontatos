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
     
  before_filter :verificar_acesso_nao_autorizado_twitter
     
  protected
  
  def authentication_succeeded message = nil
    super
  end
  
  def authentication_failed message = t("app.login_erro")
    super
  end            
  
  def verificar_acesso_nao_autorizado_twitter
    if sessions? and params[:denied]
      flash[:error] = t("app.login_nao_autorizado")
      redirect_to root_url
      return
    end
  end
  
  def sessions?
    params[:action] == 'oauth_callback' and params[:controller] == 'sessions'
  end
  
end
