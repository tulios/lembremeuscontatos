class Grupo < ActiveRecord::Base
  include LembreMeusContatos::Converters
    
  has_many :grupos_contatos
  has_many :contatos, :through => :grupos_contatos, :order => "nome asc"
                                                                                  
  attr_protected :user_id
  act_as_virtual_date :inicio                                      
  
  belongs_to :user
  
  validates_presence_of :user_id, :nome, :mensagem, :periodicidade, :inicio
  validates_numericality_of :periodicidade, :only_integer => true, :greater_than => 5
  
  def periodicidade_formatado
    "a cada #{self.periodicidade} dias" if periodicidade
  end                           
  
  def inicio_formatado
    "começando em #{self.inicio_str}"
  end                 
  
end
