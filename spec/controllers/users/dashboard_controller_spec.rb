require 'spec_helper'

describe Users::DashboardController do
  
  before :each do
    Plano.create!(:nome => "Gratuito", :num_contatos => 30, :num_grupos => 15, :periodicidade_min => 6, :preco => 0)
  end
  
  it 'deveria ajustar a conta inicial do usuario' do
    user = login Factory(:user)
    user.cadastro_completo?.should be_false
    
    get :index
    response.should be_success
                                             
    # Ter um folder no mailChimp
    current_user.folder_id.should_not be_nil
    current_user.folder_id.should == 1
    
    # Ter um plano associado, no caso o gratuito
    current_user.plano.should_not be_nil
  end
  
  it 'deveria contar a quantidade de grupos e contatos do usuario' do
    user = login Factory(:user)
    get :index
    response.should be_success
    response.should render_template :index
    
    assigns(:qtd_contatos).should_not be_nil
    assigns(:qtd_contatos).should == 0
    
    assigns(:qtd_grupos).should_not be_nil
    assigns(:qtd_grupos).should == 0
  end
  
  it 'nao deveria permitir acessar sem estar autenticado' do
    get :index
    response.should redirect_to(login_path)
  end
  
end