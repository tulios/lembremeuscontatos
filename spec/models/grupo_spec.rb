require 'spec_helper'

describe Grupo do
  include LembreMeusContatos::Converters
                        
  before(:each) do
    @grupo = Factory(:grupo)
    GrupoContato.create(:contato => Factory(:contato), :grupo => @grupo)
  end
  
  context 'quando referente a ativacao' do
    
    it "deveria definir a data de envio a partir da data de inicio" do
      @grupo.inicio_str = date_format(Grupo.inicio_minimo)
      @grupo.ativar!.should be_true         
      
      @grupo.reload.ativo?.should be_true
      @grupo.envio_str.should == @grupo.inicio_str
    end
    
  end               
  
  context 'quando referente ao agendamento' do
                                                      
    context 'quando referente a pesquisa de grupos ativos' do

      it 'deveria recuperar os grupos ativos, agendados para data informada' do
        data = Grupo.inicio_minimo
      
        # 1 grupo ativo
        @grupo.inicio_str = date_format(data)
        @grupo.ativar!.should be_true
      
        # 3 não ativos
        3.times {Factory(:grupo)}
      
        grupos = Grupo.pesquisar_envios(data)
        grupos.should_not be_nil
        grupos.size.should == 1
        grupos[0].id.should == @grupo.id
      end                                                                  
    
      it 'deveria recuperar os grupos ativos, agendados para uma data calculada com a periodicidade' do
        data = Grupo.inicio_minimo
      
        # 1 grupo ativo
        @grupo.inicio_str = date_format(data)
        @grupo.ativar!.should be_true
      
        # 3 não ativos
        3.times {Factory(:grupo)}
        
        data += @grupo.periodicidade.days
        
        grupos = Grupo.pesquisar_envios(data)
        grupos.should_not be_nil
        grupos.size.should == 1
        grupos[0].id.should == @grupo.id
      end
      
    end
    
    it 'deveria agendar os grupos marcados para data mínima, atualizando a data de envio' do
      data = Grupo.inicio_minimo
      
      @grupo.inicio_str = date_format(data)
      @grupo.ativar!.should be_true
                           
      Grupo.agendar_envios!(data).should be_true
      @grupo.reload.envio.should == data
    end
    
    it 'deveria agendar os grupos marcados para outra data, atualizando a data de envio' do
      data = Grupo.inicio_minimo + 1.day
      
      @grupo.inicio_str = date_format(data)
      @grupo.ativar!.should be_true
                           
      Grupo.agendar_envios!(data).should be_true
      @grupo.reload.envio.should == data
    end
    
  end
  
end