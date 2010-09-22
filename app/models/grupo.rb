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
  validates_numericality_of :periodicidade, :only_integer => true
  validate :periodicidade_minima
  
  #--
  # Configuracoes ===============================================================================================
  #++
  
  attr_protected :user_id
  act_as_virtual_date :inicio, :envio
  
  alias_column :original => 'nome', :new => 'subject'
  alias_column :original => 'nome', :new => 'name'
  
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
                :on_transition => [:agendar_envio]
  end                                              
  
  aasm_event :desativar do
    transitions :from => [:ativo], 
                :to => :inativo, 
                :on_transition => [:interromper_agendamento]
  end                                              
  
  #--
  # Metodos =====================================================================================================
  #++
  
  def content
    [
      I18n.t("app.grupo.email.cabecalho", :nome => self.user.nome, :twitter => self.user.login),
      self.mensagem
    ].join("<br/><br/>")
  end
  
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
    self.envio
  end   
  
  def campaign_title
    "#{self.user.folder_name}-#{self.nome}"
  end               
  
  # Recupera os grupos ativos, agendados, e que devem ser enviados na data informada, com base na periodicidade cadastrada.
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
        "(envio + (periodicidade * '1 day'::interval) = ? or envio = ?) and status = ? and agendado = ?", 
        data, data, Grupo.status_ativo, true
      ]
    )
  end
  
  # Método chamado pela tarefa do cron (lib/tasks/cron.rake) para agendar o envio das mensagens.
  # Esse método será chamado uma vez por dia.
  #
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
  
  def self.inicio_minimo               
    # A dupla conversao eh para remover as horas.
    2.days.from_now.to_date.to_datetime
  end
  
  # ==========================================================================================================================
  private
  # ==========================================================================================================================
  
  def pode_ativar?
    possui_contatos? and data_inicio_minima? and segmentos_corretos?
  end                       
  
  def possui_contatos?
    unless self.contatos.length > 0
      errors.add(:contatos, I18n.t("app.grupo.erro.contatos_maior_zero"))
      return false
    end  
    true
  end
  
  def data_inicio_minima?
    if self.inicio.blank? or inicio_to_datetime < Grupo.inicio_minimo
      errors.add(:inicio, I18n.t("app.grupo.erro.inicio_menor_estipulado"))
      return false
    end
    true
  end
  
  def segmentos_corretos?
    unless segments_correct?
      errors.add(:status, I18n.t("app.mailchimp.erro_test_segment"))
      return false
    end
    true
  end
  
  def periodicidade_minima
    if periodicidade and periodicidade < user.plano.periodicidade_min
      errors.add(:periodicidade, I18n.t("app.grupo.erro.periodicidade_minima", :valor => user.plano.periodicidade_min))
    end
  end
  
  def agendar_envio
    self.envio = self.inicio
    self.agendado = true
  end
  
  def interromper_agendamento
    self.inicio = nil
    self.envio = nil
    if self.agendado?
      self.agendado = false   
      
      # Defaz o agendamento no mailchimp se ele tiver sido feito    
      campaign = find_campaign
      self.unschedule_campaign if campaign and campaign['status'] != "save"
    end
  end
     
  def inicio_to_datetime
    self.inicio.to_datetime.in_time_zone(Time.zone.name) if self.inicio
  end
  
end

































