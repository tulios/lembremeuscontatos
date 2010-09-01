require 'spec_helper'

describe Contato do

  before(:each) { @contato = Factory(:contato) }
  subject { @contato }

  context 'quando referente as associações' do
    it { should belong_to :user }
    it { should have_many :grupos_contatos }
  end

  context 'quando referente aos campos obrigatórios' do
    it { should validate_presence_of :nome }
    it { should validate_presence_of :user_id }
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of(:email).scoped_to(:user_id) }
  end

  it 'deveria pesquisar pelo nome'

end
