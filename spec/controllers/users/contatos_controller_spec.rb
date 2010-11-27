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
  
  context "quando referente as operacoes basicas de contato" do
  
    before :each do
      @user = login Factory(:user)
    end
  
    it 'deveria pesquisar contatos pelo nome' do
      contato = Factory(:contato, :user_id => @user.id)
      get :pelo_nome, :nome => contato.nome
      response.should be_success
      assigns(:contatos).should_not be_nil
      assigns(:contatos).size.should == 1
    end
  
    it 'deveria carregar o formulario de cadastramento' do
      get :new
      response.should be_success
      response.should render_template "users/contatos/new.html.erb"
      assigns(:contato).should_not be_nil
    end
  
    it 'deveria permitir cadastrar um contato' do
      post :create, :contato => {
        :nome => "Meu contato",
        :email => "meu_contato@gmail.com"
      }
      response.should be_success
      response.should render_template "users/contatos/create.html.erb"
      assigns(:contato).should_not be_nil
      assigns(:contato).user.id.should == @user.id
    end                      
  
    it 'deveria exibir a tela de cadastramento em caso de falha na criacao do usuario' do
      post :create, :contato => {
        :nome => "", # nome eh obrigatorio
        :email => "meu_contato@gmail.com"
      }
      response.should be_success
      response.should render_template "users/contatos/new.html.erb"
    end
    
    it 'deveria permitir apagar' do
      contato = Factory(:contato, :user_id => @user.id)
      count = Contato.count
      
      Contato.should have(count).records
      delete :destroy, :id => contato.id
      response.should redirect_to(:controller => "users/contatos", :action => :index)
      Contato.should have(count - 1).records
    end
                         
    it 'somente deveria permitir carregar o formulario se o plano permitir' do
      @user.plano.num_contatos = 0
      @user.plano.save.should be_true
      lambda {
        get :new
      }.should raise_error(LembreMeusContatos::Exceptions::BadBehavior)
    end
    
    it 'somente deveria permitir criar se o plano permitir' do
      @user.plano.num_contatos = 0
      @user.plano.save.should be_true
      
      lambda {
        post :create, :contato => {
          :nome => "Meu contato",
          :email => "meu_contato@gmail.com"
        }       
      }.should raise_error(LembreMeusContatos::Exceptions::BadBehavior)
    end
    
    it 'nao deveria permitir apagar caso o usuario logado nao seja o dono' do
      user2 = Factory(:user)
      contato = Factory(:contato, :user_id => user2.id)
      count = Contato.count
      
      Contato.should have(count).records
      lambda {
        delete :destroy, :id => contato.id
      }.should raise_error(LembreMeusContatos::Exceptions::BadBehavior)
      
      Contato.should have(count).records
    end
    
  end
  
  context 'quando referente a operacoes sem usuario logado' do
    
    it { get :index; response.should redirect_to(login_path) }
    it { get :index_ajax; response.should redirect_to(login_path) }
    it { get :new; response.should redirect_to(login_path) }
    it { get :pelo_nome; response.should redirect_to(login_path) }
    it { post :create; response.should redirect_to(login_path) }
    it { delete :destroy; response.should redirect_to(login_path) }
    
  end
  
end


















































