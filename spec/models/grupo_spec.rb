require 'spec_helper'

describe Grupo do
  include LembreMeusContatos::Converters
                        
  before(:each) { @grupo = Factory(:grupo) }
  
  context 'quando referente a ativacao' do
    
    it "deveria definir a data de envio a partir da data de inicio" do
      GrupoContato.create(:contato => Factory(:contato), :grupo => @grupo)
      
      @grupo.inicio_str = date_format(Grupo.inicio_minimo)
      @grupo.ativar!.should be_true         
      
      @grupo.reload.ativo?.should be_true
      @grupo.envio_str.should == @grupo.inicio_str
    end
    
  end
  
end