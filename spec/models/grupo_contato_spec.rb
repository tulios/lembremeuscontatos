require 'spec_helper'

describe GrupoContato do

  before(:each) { @grupo_contato = Factory(:grupo_contato) }
  subject { @grupo_contato }

  context 'quando referente a associações' do
    it { should belong_to :grupo }
    it { should belong_to :contato }
  end

  context 'quando referente a parametros obrigatórios' do
    it { should validate_presence_of :grupo_id }
    it { should validate_presence_of :contato_id }
  end

end
