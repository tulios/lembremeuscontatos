class Contato < ActiveRecord::Base
                  
  attr_protected :user_id
  belongs_to :user
  
  validates_presence_of :nome, :email, :user_id
  validates_uniqueness_of :email
                         
  def self.pesquisar_pelo_nome nome, user
    return nil if nome.nil? or nome.empty?
    
    # parameterize tira os acentos
    Contato.find(
      :all, 
      :conditions => ["#{retirar_acentos('nome')} like lower(?) and user_id = ?", "%#{nome.parameterize}%", user.id], 
      :order => 'nome asc'
    )                       
  end
  
  private
  def self.retirar_acentos campo
    "translate(lower(#{campo}), 'áâãéêẽíóôõú', 'aaaeeeiooou')"
  end
  
end
