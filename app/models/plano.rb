class Plano < ActiveRecord::Base
  validates_presence_of :nome
  
  def self.gratuito
    Plano.find_by_nome("Gratuito")
  end
  
end

