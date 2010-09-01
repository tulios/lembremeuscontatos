require 'spec_helper'

describe Grupo do

  before(:each) { @grupo = Factory(:grupo) }
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
    it { should validate_presence_of :inicio }
  end

  context 'quanto a presença de alias de colunas' do
    it { should respond_to :subject }
    it { should respond_to :name }
    it { should respond_to :content }
  end

end
