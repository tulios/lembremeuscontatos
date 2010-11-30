require 'spec_helper'

describe Users::GruposController do
  include LembreMeusContatos::Converters
  
  context "quando referente as operacoes basicas de grupo" do
    
    before :each do
      @user = login Factory(:user)
    end
    
    it 'deveria carregar o index' do
      2.times {Factory(:grupo, :user_id => @user.id)}
      get :index
      response.should be_success
      response.should render_template("users/grupos/index.html.erb")
      assigns(:grupos).should_not be_nil
      assigns(:grupos).size.should == 2
    end
                                                    
    it 'deveria carregar o formulario de cadastramento' do
      get :new
      response.should be_success
      response.should render_template("users/grupos/new.html.erb")
      assigns(:grupo).should_not be_nil
    end
    
    it 'deveria criar' do
      contato = Factory(:contato, :user_id => @user.id)
      
      post :create, :grupo => {
        :nome => "nome grupo",
        :mensagem => "mensagem",
        :periodicidade => "7"
      }, :contatos => [contato.id]                            
      
      response.should redirect_to(:controller => "users/grupos", :action => :index)
      assigns(:grupo).should_not be_nil
      assigns(:grupo).user.id.should == @user.id
      assigns(:grupo).reload.contatos.should_not be_nil
      assigns(:grupo).contatos.size.should == 1
    end
    
    it 'deveria recuperar os contatos escolhidos ao falhar na criacao' do
      contato = Factory(:contato, :user_id => @user.id)
      count = Contato.count
      Contato.should have(count).records
      
      post :create, :grupo => {
        :nome => "", # obrigatorio, nao pode criar
        :mensagem => "mensagem",
        :periodicidade => "7"
      }, :contatos => [contato.id]                            
      
      response.should render_template("users/grupos/new.html.erb")
      Contato.should have(count).records
      
      assigns(:contatos_temporarios).should_not be_nil
      assigns(:contatos_temporarios).first.id.should == contato.id
    end
    
    it 'deveria editar' do
      grupo = Factory(:grupo, :user_id => @user.id)
      get :edit, :id => grupo.id
      
      response.should be_success
      response.should render_template("users/grupos/edit.html.erb")
      assigns(:grupo).should_not be_nil
      assigns(:grupo).id.should == grupo.id
    end
    
    it 'deveria atualizar' do
      grupo = Factory(:grupo, :user_id => @user.id)
      contato = Factory(:contato, :user_id => @user.id)
      grupo.contatos << contato
      grupo.save.should be_true

      grupo.reload.contatos.size > 0
      grupo.reload.inativo?.should be_true
      
      put :update, :id => grupo.id, :grupo => { :nome => "novo nome" }
      response.should redirect_to(:controller => "users/grupos", :action => :index)
      
      grupo.reload.nome.should == "novo nome"
    end
    
    it 'deveria recuperar os contatos escolhidos ao falhar na atualizacao' do
      grupo = Factory(:grupo, :user_id => @user.id)
      contato = Factory(:contato, :user_id => @user.id)
      grupo.contatos << contato
      grupo.save.should be_true

      grupo.reload.contatos.size > 0
      grupo.reload.inativo?.should be_true
      
      novo_contato = Factory(:contato, :user_id => @user.id)
      
      put :update, :id => grupo.id, :grupo => { :nome => "" }, :contatos => [novo_contato.id]
      response.should render_template(:edit)          
      
      assigns(:contatos_temporarios).should_not be_nil
      assigns(:contatos_temporarios).first.id.should == novo_contato.id
    end
    
    it 'deveria recuperar para visualizacao' do
      grupo = Factory(:grupo, :user_id => @user.id)
      contato = Factory(:contato, :user_id => @user.id)
      grupo.contatos << contato
      grupo.save.should be_true
      
      get :show, :id => grupo.id
      response.should be_success
      response.should render_template(:show)
      
      assigns(:grupo).should_not be_nil
      assigns(:grupo).id.should == grupo.id
      assigns(:inicio_minimo).should_not be_nil
    end                                        
    
    it 'deveria apagar' do
      grupo = Factory(:grupo, :user_id => @user.id)
      count = Grupo.count
      Grupo.should have(count).records                                
      
      delete :destroy, :id => grupo.id
      response.should redirect_to(:controller => "users/grupos", :action => :index)
      
      Grupo.should have(count - 1).records
    end
    
    it 'deveria apagar sem apagar o contato associado' do
      grupo = Factory(:grupo, :user_id => @user.id)
      contato = Factory(:contato, :user_id => @user.id)
      grupo.contatos << contato
      grupo.save.should be_true
      
      count = Grupo.count
      Grupo.should have(count).records                                
      
      delete :destroy, :id => grupo.id
      response.should redirect_to(:controller => "users/grupos", :action => :index)
      
      Grupo.should have(count - 1).records
      Contato.find(contato.id).should_not be_nil
    end
    
  end
  
  context "quando referente a permissoes" do
    
    before :each do
      @user = login Factory(:user)
    end
                 
    it 'nao deveria permitir criar um grupo com contatos que nao sejam do usuario logado' do
      user2 = Factory(:user)
      contato = Factory(:contato, :user_id => user2.id)

      lambda {
        post :create, :grupo => {
          :nome => "nome grupo",
          :mensagem => "mensagem",
          :periodicidade => "7"
        }, :contatos => [contato.id]
      }.should raise_error(LembreMeusContatos::Exceptions::BadBehavior)
    end
    
    it 'nao deveria permitir editar um grupo de outro usuario' do
      user2 = Factory(:user)
      grupo = Factory(:grupo, :user_id => user2.id)
      
      lambda {
        get :edit, :id => grupo.id
      }.should raise_error(LembreMeusContatos::Exceptions::BadBehavior)
    end
    
    it 'nao deveria permitir editar um grupo ativo' do
      grupo = Factory(:grupo_contato).grupo
      grupo.user_id = @user.id
      grupo.save.should be_true
      
      grupo.inicio_str = date_format(Grupo.inicio_minimo)
      grupo.ativar!.should be_true
      
      lambda {
        get :edit, :id => grupo.id
      }.should raise_error(LembreMeusContatos::Exceptions::BadBehavior)
    end
    
    it 'nao deveria permitir atualizar um grupo com contatos que nao sejam do usuario logado' do
      grupo = Factory(:grupo, :user_id => @user.id)
      contato = Factory(:contato, :user_id => @user.id)
      grupo.contatos << contato
      grupo.save.should be_true

      grupo.reload.contatos.size > 0
      grupo.reload.inativo?.should be_true
      
      user2 = Factory(:user)
      contato = Factory(:contato, :user_id => user2.id)
      
      lambda {
        put :update, :id => grupo.id, :grupo => { :nome => "novo nome" }, :contatos => [contato.id]
      }.should raise_error(LembreMeusContatos::Exceptions::BadBehavior)
      
      grupo.reload.nome.should_not == "novo nome"
    end
    
    it 'nao deveria permitir visualizar um grupo de outro usuario' do
      user2 = Factory(:user)
      grupo = Factory(:grupo, :user_id => user2.id)

      lambda {
        get :show, :id => grupo.id
      }.should raise_error(LembreMeusContatos::Exceptions::BadBehavior)
    end
                      
    it 'nao deveria permitir apagar o grupo de outro usuario' do
      user2 = Factory(:user)
      grupo = Factory(:grupo, :user_id => user2.id)
      
      lambda {
        delete :destroy, :id => grupo.id
      }.should raise_error(LembreMeusContatos::Exceptions::BadBehavior)
    end
    
  end
  
  context 'quando referente a operacoes sem usuario logado' do
    
    it { get :index; response.should redirect_to(login_path) }
    it { get :new; response.should redirect_to(login_path) }
    it { post :create; response.should redirect_to(login_path) }
    it { delete :destroy; response.should redirect_to(login_path) }
    it { get :edit; response.should redirect_to(login_path) }
    it { post :update; response.should redirect_to(login_path) }
    it { get :show; response.should redirect_to(login_path) }
    
  end
  
end






























