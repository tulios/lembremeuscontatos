require 'spec_helper'

describe Users::AgendamentoController do
  include LembreMeusContatos::Converters
                                                                                
  context 'quando referente as operacoes basicas' do
      
    before :each do
      @user = login Factory(:user)
      @grupo = Factory(:grupo, :user_id => @user.id)
      @contato = Factory(:contato, :user_id => @user.id)
      @grupo.contatos << @contato
      @grupo.save
    end
    
    it 'deveria agendar um envio' do
      post :create, :grupo_id => @grupo.id, :inicio_str => date_format(Grupo.inicio_minimo)
      response.should redirect_to(users_grupos_url)
      @grupo.reload.ativo?.should be_true
      @grupo.qtd_envios.should == 0
      @grupo.qtd_enviada.should == 0
    end
    
    it 'deveria agendar um envio definindo a quantidade de envios' do
      post :create, :grupo_id => @grupo.id, 
                    :inicio_str => date_format(Grupo.inicio_minimo),
                    :qtd_envios => "5"
                    
      response.should redirect_to(users_grupos_url)
      @grupo.reload.ativo?.should be_true
      @grupo.qtd_envios.should == 5
      @grupo.qtd_enviada.should == 0
    end
    
    it 'nao deveria agendar grupos ativos' do
      @grupo.inicio_str = date_format(Grupo.inicio_minimo)
      @grupo.ativar!
      
      @grupo.reload.ativo?.should be_true
      post :create, :grupo_id => @grupo.id, :inicio_str => date_format(Grupo.inicio_minimo)
      response.should be_success
      response.should render_template("users/grupos/show")
      assigns(:inicio_minimo).should_not be_nil
    end
    
    it 'deveria cancelar um agendamento' do
      @grupo.inicio_str = date_format(Grupo.inicio_minimo)
      @grupo.ativar!
      
      @grupo.reload.ativo?.should be_true
      
      delete :destroy, :grupo_id => @grupo.id
      response.should redirect_to(users_grupos_url)
      
      @grupo.reload.inativo?.should be_true
    end               
    
    it 'nao deveria desativar um grupo inativo' do
      delete :destroy, :grupo_id => @grupo.id
      response.should render_template("users/grupos/show")
      assigns(:inicio_minimo).should_not be_nil
      
      @grupo.reload.inativo?.should be_true
    end
       
  end
  
  context 'quando referente a permissoes' do
    
    before :each do
      @user = login Factory(:user)
      @grupo = Factory(:grupo, :user_id => @user.id)
      @contato = Factory(:contato, :user_id => @user.id)
      @grupo.contatos << @contato
      @grupo.save
    end
    
    it 'nao deveria permitir agendar um grupo de outro usuario' do
      user2 = Factory(:user)
      grupo = Factory(:grupo, :user_id => user2.id)
      
      lambda {
        post :create, :grupo_id => grupo.id, :inicio_str => date_format(Grupo.inicio_minimo)
      }.should raise_error(LembreMeusContatos::Exceptions::BadBehavior)
    end
    
    it 'nao deveria permitir cancelar o agendamento de um grupo de outro usuario' do
      user2 = Factory(:user)
      grupo = Factory(:grupo, :user_id => user2.id)
      
      lambda {
        delete :destroy, :grupo_id => grupo.id
      }.should raise_error(LembreMeusContatos::Exceptions::BadBehavior)
    end
    
  end
  
  context 'quando referente a operacoes sem usuario logado' do
    
    it { post :create; response.should redirect_to(login_path) }
    it { delete :destroy; response.should redirect_to(login_path) }
    
  end
  
end







































