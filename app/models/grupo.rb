class Grupo < ActiveRecord::Base
  include AASM
  include LembreMeusContatos::Converters
  include LembreMeusContatos::StateMachineSupport
  include Hominid::Adapter       
                       
  QTD_INDETERMINADA = 0
  
  #--
  # Associacoes =================================================================================================  
  #++
  
  belongs_to :user
  has_many :grupos_contatos
  has_many :contatos, :through => :grupos_contatos, :order => "nome asc"
  
  #--
  # Callbacks ===================================================================================================  
  #++
  
  before_validation :inicializar_total_envios, :inicializar_qtd_envios
  
  #--
  # Validacoes ==================================================================================================  
  #++
  
  validates_presence_of :user_id, :nome, :mensagem, :periodicidade
  validates_numericality_of :periodicidade, :only_integer => true, :greater_than => 0
  validates_numericality_of :qtd_envios, :only_integer => true, :greater_than_or_equal_to => 0
  validate :periodicidade_minima
  
  #--
  # Configuracoes ===============================================================================================
  #++
  
  attr_protected :user_id, :total_envios, :qtd_enviada
  act_as_virtual_date :inicio, :envio
  
  alias_column :original => 'nome', :new => 'subject'
  alias_column :original => 'nome', :new => 'name'
  alias_column :original => 'envio', :new => "start_date"
  
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
                :on_transition => [:limpar_qtd_enviada, :agendar_envio]
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
  
  def emails
    self.contatos(:force_reload => true).collect {|contato| contato.email}
  end
  
  def qtd_envios_indeterminada?
    self.qtd_envios == QTD_INDETERMINADA
  end
  
  def inicio_formatado; "começando em #{self.inicio_str}" end
  def qtd_envios_formatado; "#{self.qtd_envios} vezes" end
  def status_str; self.status.upcase end
  def folder_id; user.folder_id end
  def adicionar_segmentos; add_segment end
  def campaign_title; "#{self.user.folder_name}-#{self.nome}" end
  
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
      grupo.qtd_enviada += 1
      grupo.total_envios += 1
      
      grupo.save!
      grupo.schedule_campaign
    end
    
    true
  rescue => e                           
    Rails.logger.error e.message
    return false
  end
  
  # Recupera os grupos cuja qtd_envios > qtd_enviada e que nao sejam de envio indeterminado,
  # ou seja, qtd_envios = 0
  #
  def self.pesquisar_desativacoes data = Date.today, indeterminada = QTD_INDETERMINADA
    Grupo.find(
      :all, :conditions => [
        %Q{
          (envio + (periodicidade * '1 day'::interval) = ? or envio = ?) and 
          status = ? and 
          agendado = ? and
          qtd_envios > ? and
          qtd_enviada >= qtd_envios
        }, 
        data, data, Grupo.status_ativo, true, indeterminada
      ]
    )
  end
    
  # Desativa os grupos cuja quantidade de envios ja tenha sido satisfeita. Recupera os grupos em
  # today - 1.day pois o agendamento no mailChimp foi feito a 2 dias e vamos manter 1 dia de folga.
  #
  def self.desativar_enviados! data = (Date.today - 1.day.to_date) # Grupos enviados ontem
      grupos = Grupo.pesquisar_desativacoes(data)
      grupos.each do |grupo|
        grupo.desativar!
      end

      true
  rescue => e                           
    Rails.logger.error e.message
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
  
  def limpar_qtd_enviada
    self.qtd_enviada = 0
  end
  
  def interromper_agendamento
    self.inicio = nil
    self.envio = nil
    if self.agendado?
      self.agendado = false   
      
      # Desfaz o agendamento no mailchimp se ele tiver sido feito    
      self.unschedule_or_recreate_campaign unless Rails.env.test?
    end
  end
  
  def inicio_to_datetime
    self.inicio.to_datetime.in_time_zone(Time.zone.name) if self.inicio
  end
  
  def inicializar_total_envios
    self.total_envios = 0 unless self.total_envios
  end
  
  def inicializar_qtd_envios
    self.qtd_envios = 0 unless self.qtd_envios
  end
  
end

































