require 'spec_helper'

describe Users::GruposContatosController do
  
  context 'quando referente as operacoes basicas' do
                                                                
    before :each do
      @user = login Factory(:user)
      @grupo = Factory(:grupo, :user_id => @user.id)
      @contato = Factory(:contato, :user_id => @user.id)
      @grupo.contatos << @contato
      @grupo.save
    end
    
    it 'deveria apagar o relacionamento de contato com grupo' do
      count = GrupoContato.count
      GrupoContato.should have(count).records
      
      delete :destroy, :id => @grupo.id
      response.should be_success
      
      GrupoContato.should have(count - 1).records
    end
    
    it 'nao deveria permitir apagar um grupo_contato de outro usuario' do
      user2 = login Factory(:user)
      count = GrupoContato.count
      GrupoContato.should have(count).records

      lambda {
        delete :destroy, :id => @grupo.id
      }.should raise_error(LembreMeusContatos::Exceptions::BadBehavior)
      
      GrupoContato.should have(count).records
    end
    
  end
  
  context 'quando referente a operacoes sem usuario logado' do
    
    it { delete :destroy; response.should redirect_to(login_path) }
  
  end
  
end