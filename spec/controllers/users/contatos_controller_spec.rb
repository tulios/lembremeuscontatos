require 'spec_helper'

describe Users::ContatosController do
                                       
  context 'quando referente ao metodo index' do
    
    before :each do
      @user1 = Factory(:user)
      @user2 = login Factory(:user)
    
      # Contatos de outro usuario
      3.times {Factory(:contato, :user_id => @user1.id)}
      # Contato do usuario logado
      Factory(:contato, :user_id => @user2.id)
    end
    
    it 'deveria carregar a lista de contatos de um usuario' do
      get :index
      response.should be_success
      response.should render_template :index
    
      assigns(:contatos).should_not be_nil
      assigns(:contatos).size.should == 1
    end      
    
    it 'deveria carregar a lista de contatos renderizando apenas o list' do
      get :index_ajax
      response.should be_success
      response.should render_template 'users/contatos/_list'
    
      assigns(:contatos).should_not be_nil
      assigns(:contatos).size.should == 1
    end
  
  end
  
end