require 'spec_helper'

describe Contato do

  before(:each) { @contato = Factory(:contato) }
  subject { @contato }

  context 'quando referente as associações' do
    it { should belong_to :user }
    it { should have_many :grupos_contatos }
    
    it 'deveria retornar GrupoUsuario com base no grupo' do
      grupo_contato = Factory(:grupo_contato)
      contato = grupo_contato.contato
      
      resultado = contato.associacao grupo_contato.grupo
      resultado.should_not be_nil
      resultado.id.should == grupo_contato.id
    end
  end

  context 'quando referente aos campos obrigatórios' do
    it { should validate_presence_of :nome }
    it { should validate_presence_of :user_id }
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of(:email).scoped_to(:user_id) }
  end
                           
  context 'quando referente as pesquisas' do
    it 'deveria pesquisar pelo nome' do
      contato = Factory(:contato)
      
      resultado = Contato.pesquisar_pelo_nome contato.nome, contato.user
      resultado.should_not be_nil
      resultado.size.should == 1
    end

    it 'deveria utilizar o metodo pesquisar' do
      3.times {Factory(:contato)}
      resultado = Contato.pesquisar :conditions => ["email = ?", @contato.email]
      resultado.should_not be_nil
      resultado.size.should == 1
    end
    
    it 'deveria paginar os resultados' do
      (LembreMeusContatos::PAGE_SIZE + 1).times {Factory(:contato)}
      resultado = Contato.pesquisar :conditions => ["email like ?", "contato%"]
      resultado.should_not be_nil
      resultado.size.should == LembreMeusContatos::PAGE_SIZE
      
      resultado = Contato.pesquisar :conditions => ["email like ?", "contato%"], :page => 2
      resultado.should_not be_nil
      resultado.size.should == 2 # +1 do before(:each)
    end
    
  end

end
