class Grupo < ActiveRecord::Base
  include AASM
  include LembreMeusContatos::Converters
  include LembreMeusContatos::StateMachineSupport
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
  
  validates_presence_of :user_id, :nome, :mensagem, :periodicidade
  validates_numericality_of :periodicidade, :only_integer => true, :greater_than => 5
  
  #--
  # Configuracoes ===============================================================================================
  #++
  
  attr_protected :user_id
  act_as_virtual_date :inicio, :envio
  
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
                :on_transition => [:atualizar_envio, :schedule_campaign]
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
                  
  def status_str
    self.status.upcase
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
  
  def start_date
    self.inicio
  end   
  
  def campaign_title
    "#{self.user.folder_name}-#{self.nome}"
  end               
  
  # Recupera os grupos ativos, que devem ser enviados na data informada, com base na periodicidade cadastrada.
  # ex:
  #   Grupo.pesquisar_envios(Date.today)
  #     => inicio + periodicidade em dias = hoje
  #   Grupo.pesquisar_envios(8.days.from_now.to_date)
  #   
  #   '8.days.from_now.to_date' precisa do to_date pois o tempo não deve ser considerado.
  #   Grupo.pesquisar_envios já recupera os grupos agendados para Date.today.
  #
  def self.pesquisar_envios data = Date.today
    Grupo.find(
      :all, :conditions => [
        "(envio + (periodicidade * '1 day'::interval) = ? or envio = ?) and status = ?", 
        data, data, Grupo.status_ativo
      ]
    )
  end
  
  def self.agendar_envios! data = 2.days.from_now.to_date # 2 dias no futuro
    
    grupos = Grupo.pesquisar_envios(data)
    grupos.each do |grupo|
      grupo.envio = data
      grupo.save!
      grupo.schedule_campaign
    end
    
    true
  rescue => e
    RAILS_DEFAULT_LOGGER.error e.message
    return false
  end
  
  # ==========================================================================================================================
  private
  # ==========================================================================================================================
  
  def pode_ativar?
    possui_contatos? and segmentos_corretos? and data_inicio_minima?
  end                       
  
  def possui_contatos?
    unless self.contatos.length > 0
      errors.add(:contatos, I18n.t("app.grupo.erro.contatos_maior_zero"))
      return false
    end  
    true
  end
                         
  def segmentos_corretos?
    segments_correct?
  end
  
  def atualizar_envio
    self.envio = self.inicio
  end
     
  def self.inicio_minimo               
    # A dupla conversao eh para remover as horas.
    2.days.from_now.to_date.to_datetime
  end
                                                                                             
  def data_inicio_minima?
    if self.inicio.nil? or inicio_to_datetime < Grupo.inicio_minimo
      errors.add(:inicio, I18n.t("app.grupo.erro.inicio_menor_estipulado"))
      return false
    end
    true
  end
  
  def inicio_to_datetime
    self.inicio.to_datetime.in_time_zone(Time.zone.name) if self.inicio
  end
  
end

































