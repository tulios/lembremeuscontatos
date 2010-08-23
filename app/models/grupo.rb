class Grupo < ActiveRecord::Base
                                                                                  
  attr_protected :user_id
  
  belongs_to :user
  
  validates_presence_of :user_id, :nome, :mensagem, :periodicidade, :inicio
  validates_numericality_of :periodicidade, :only_integer => true, :greater_than => 5
  
end
