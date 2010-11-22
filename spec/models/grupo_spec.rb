require 'spec_helper'

describe Grupo do
  include LembreMeusContatos::Converters

  before(:each) { @grupo = Factory(:grupo_contato).grupo }
  subject { @grupo }

  context 'quando referente a associações' do
    it { should belong_to :user }
    it { should have_many :grupos_contatos }
    it { should have_many(:contatos).through(:grupos_contatos) }
  end

  context 'quando referente a parametros obrigatórios' do
    it { should validate_presence_of :user_id }
    it { should validate_presence_of :nome }
    it { should validate_presence_of :mensagem }
    it { should validate_presence_of :periodicidade }
    it { should validate_numericality_of :periodicidade }
    it { should validate_numericality_of :qtd_envios }
    
    it 'qtd_envios deve ser um numero maior que zero' do
      @grupo.qtd_envios = -1
      @grupo.save.should be_false
    end
    
  end

  context 'quanto a presença de alias de colunas' do
    it { should respond_to :subject }
    it { should respond_to :name }
    it { should respond_to :content }
    it { should respond_to :start_date}
    it { should respond_to :folder_id}
    it { should respond_to :campaign_title}
  end
                                       
  context 'quando referente a formatacao' do
    it 'deveria retornar o content com o nome do usuario' do
      (@grupo.content =~ /#{@grupo.user.nome}/).should be_true
      (@grupo.content =~ /#{@grupo.user.login}/).should be_true
    end
    
    it { @grupo.periodicidade_formatado.should == "a cada #{@grupo.periodicidade} dias" }
    it { @grupo.inicio_formatado.should == "começando em #{@grupo.inicio_str}" }
    it { @grupo.status_str.should == @grupo.status.upcase }
  end

  context 'quando referente a ativacao' do
    
    it "deveria definir a data de envio a partir da data de inicio" do
      @grupo.inicio_str = date_format(Grupo.inicio_minimo)
      @grupo.ativar!.should be_true         
      
      @grupo.reload.ativo?.should be_true
      @grupo.envio_str.should == @grupo.inicio_str
    end
    
    it "deveria manter o qtd_envios em zero, caso nao seja informado" do
      @grupo.inicio_str = date_format(Grupo.inicio_minimo)
      @grupo.ativar!.should be_true         
      
      @grupo.reload.ativo?.should be_true
      @grupo.envio_str.should == @grupo.inicio_str
      @grupo.qtd_envios.should == 0
    end
    
    it "deveria limpar a qtd_enviada, pois esta eh apenas para o controle do qtd_envios" do
      @grupo.qtd_enviada = 10
      @grupo.save(false).should be_true
      
      @grupo.reload.qtd_enviada.should == 10
      
      @grupo.inicio_str = date_format(Grupo.inicio_minimo)
      @grupo.ativar!.should be_true         
      
      @grupo.reload.ativo?.should be_true
      @grupo.envio_str.should == @grupo.inicio_str
      @grupo.qtd_enviada.should == 0
    end
    
  end               
                  
  context 'quando referente a pesquisa' do
    it 'deveria utilizar o metodo pesquisar' do
      3.times {Factory(:grupo)}
      resultado = Grupo.pesquisar :conditions => ["nome = ?", @grupo.nome]
      resultado.should_not be_nil
      resultado.size.should == 1
    end
    
    it 'deveria paginar os resultados' do
      (LembreMeusContatos::PAGE_SIZE + 1).times {Factory(:grupo)}
      resultado = Grupo.pesquisar :conditions => ["nome like ?", "Nome%"]
      resultado.should_not be_nil
      resultado.size.should == LembreMeusContatos::PAGE_SIZE
      
      resultado = Grupo.pesquisar :conditions => ["nome like ?", "Nome%"], :page => 2
      resultado.should_not be_nil
      resultado.size.should == 2 # +1 do before(:each)
    end
  end
  
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
  
  context 'quando referente ao agendamento' do
                                                      
    it 'deveria agendar os grupos marcados para data mínima, atualizando a data de envio' do
      data = Grupo.inicio_minimo
      
      @grupo.inicio_str = date_format(data)
      @grupo.ativar!.should be_true
                           
      Grupo.agendar_envios!(data).should be_true
      @grupo.reload.envio.should == data
      @grupo.agendado?.should be_true
    end
    
    it 'deveria agendar os grupos marcados para outra data, atualizando a data de envio' do
      data = Grupo.inicio_minimo + 1.day
      
      @grupo.inicio_str = date_format(data)
      @grupo.ativar!.should be_true
                           
      Grupo.agendar_envios!(data).should be_true
      @grupo.reload.envio.should == data
      @grupo.agendado?.should be_true
    end
    
    it 'deveria incrementar o total de envios e a qtd enviada' do
      data = Grupo.inicio_minimo
      
      @grupo.inicio_str = date_format(data)
      @grupo.ativar!.should be_true
      @grupo.qtd_enviada.should == 0
      @grupo.total_envios.should == 0
                           
      Grupo.agendar_envios!(data).should be_true
      @grupo.reload.envio.should == data
      @grupo.agendado?.should be_true
      @grupo.qtd_enviada.should == 1
      @grupo.total_envios.should == 1
    end
                                     
  end
  
  context 'quando referente a pesquisa de desativacoes' do
    
    it 'deveria recuperar grupos cuja quantidade de envio ja tenha sido utilizada' do
      data = Grupo.inicio_minimo
    
      # 3 não ativos
      3.times {Factory(:grupo)}
    
      # 1 grupo ativo
      @grupo.inicio_str = date_format(data)
      @grupo.qtd_envios = 1
      @grupo.ativar!.should be_true
      
      # Simulando o envio
      Grupo.agendar_envios!(data).should be_true
      @grupo.reload.ativo?.should be_true
      @grupo.qtd_enviada.should == 1
      @grupo.total_envios.should == 1
    
      grupos = Grupo.pesquisar_desativacoes(data)
      grupos.should_not be_nil
      grupos.size.should == 1
      grupos.first.id.should == @grupo.id
    end     
    
    it 'nao deveria recuperar grupos de envio indeterminado' do
      data = Grupo.inicio_minimo
      
      # 3 não ativos
      3.times {Factory(:grupo)}
      
      @grupo.inicio_str = date_format(data)
      @grupo.qtd_envios = Grupo::QTD_INDETERMINADA
      @grupo.ativar!.should be_true
      
      Grupo.agendar_envios!(data).should be_true
      @grupo.reload.total_envios.should == 1
      
      grupos = Grupo.pesquisar_desativacoes(data)
      grupos.should be_blank
    end
    
  end
  
  context 'quando referente a desativacao dos grupos enviados cuja quantidade de envios ja tenha sido utilizada' do
    
    it 'deveria desativar os grupos enviados ontem' do
      data = Grupo.inicio_minimo
    
      # 3 não ativos
      3.times {Factory(:grupo)}
    
      # 1 grupo ativo
      @grupo.inicio_str = date_format(data)
      @grupo.qtd_envios = 1
      @grupo.ativar!.should be_true
      
      # Simulando o envio
      Grupo.agendar_envios!(data).should be_true
      @grupo.reload.ativo?.should be_true
      @grupo.qtd_enviada.should == 1
      @grupo.total_envios.should == 1
    
      Grupo.count(:conditions => ["status = ?", Grupo.status_inativo]).should == 3
      
      Grupo.desativar_enviados!(data).should be_true
      Grupo.count(:conditions => ["status = ?", Grupo.status_inativo]).should == 4
      @grupo.reload.inativo?.should be_true
      @grupo.total_envios.should == 1
    end
    
  end
  
end






















