class Grupo < ActiveRecord::Base
  include AASM
  include LembreMeusContatos::Converters
  include Hominid::Adapter       
  
  #--
  # Associacoes =================================================================================================  
  #++
  
  belongs_to :user
  has_many :grupos_contatos
  has_many :contatos, :through => :grupos_contatos, :order => "nome asc"
  
  #--
  # Validacoes ==================================================================================================  
  #++
  
  validates_presence_of :user_id, :nome, :mensagem, :periodicidade, :inicio
  validates_numericality_of :periodicidade, :only_integer => true, :greater_than => 5
  
  #--
  # Configuracoes ===============================================================================================
  #++
  
  attr_protected :user_id
  act_as_virtual_date :inicio                                      
  
  alias_column :original => 'nome', :new => 'subject'
  alias_column :original => 'nome', :new => 'name'
  alias_column :original => 'mensagem', :new => 'content'
  
  #--
  # MailChimp ===================================================================================================
  #++
  
  sync_with_hominid_campaign
  
  #--                                                                                                               
  # Maquina de estados ==========================================================================================
  #++
  
  aasm_column :status
  aasm_initial_state :inativo
  
  aasm_state :inativo
  aasm_state :ativo
     
  aasm_event :ativar do
    transitions :from => [:inativo], 
                :to => :ativo, 
                :guard => :pode_ativar?,
                :on_transition => [:agendar_campanha]
  end   
  
  #--
  # Metodos =====================================================================================================
  #++
  
  def periodicidade_formatado
    "a cada #{self.periodicidade} dias" if periodicidade
  end                           
  
  def inicio_formatado
    "começando em #{self.inicio_str}"
  end                 
  
  def folder_id
    user.folder_id
  end
  
  def emails
    self.contatos(:force_reload => true).collect {|contato| contato.email}
  end
  
  def adicionar_segmentos
    add_segment
  end   
  
  private
  
  def agendar_campanha
  end
  
  def pode_ativar?
    possui_contatos? and segmentos_corretos?
  end                       
  
  def possui_contatos?
    self.contatos.length > 0
  end
                         
  def segmentos_corretos?
    segments_correct?
  end  
  
end

































