class Grupo < ActiveRecord::Base
  include LembreMeusContatos::Converters
  include Hominid::Adapter       
    
  has_many :grupos_contatos
  has_many :contatos, :through => :grupos_contatos, :order => "nome asc"
                                                                                  
  attr_protected :user_id
  act_as_virtual_date :inicio                                      
  
  belongs_to :user
  
  validates_presence_of :user_id, :nome, :mensagem, :periodicidade, :inicio
  validates_numericality_of :periodicidade, :only_integer => true, :greater_than => 5
               
  alias_column :original => 'nome', :new => 'subject'
  alias_column :original => 'nome', :new => 'name'
  alias_column :original => 'mensagem', :new => 'content'
  
  sync_with_hominid_campaign
  
  def periodicidade_formatado
    "a cada #{self.periodicidade} dias" if periodicidade
  end                           
  
  def inicio_formatado
    "começando em #{self.inicio_str}"
  end                 
  
  def folder_id
    user.folder_id
  end
  
end
