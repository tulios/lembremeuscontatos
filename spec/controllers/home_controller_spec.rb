require 'spec_helper'

describe HomeController do
  
  context 'quando referente a usuarios nao autenticados' do
    
    it 'deveria carregar a tela de entrada' do
      get :index
      response.should be_success
      response.should render_template :index
    end
    
  end                                       
  
  context 'quando referente a usuarios logados' do
    
    it 'deveria redirecionar para o dashboard passando o login na url' do
      user = login Factory(:user)
      get :index
      response.should redirect_to(:controller => "users/dashboard", :action => :index, :login => user.login)
    end
    
  end
  
end