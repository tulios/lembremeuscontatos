class Ability
  include CanCan::Ability
  
  def initialize user
    # Contato
    can :destroy, Contato, :user_id => user.id
    can :create, Contato do
      Contato.count(:conditions => ["user_id = ?", user.id]) < user.plano.num_contatos
    end
    
    # Grupo
    can [:edit, :update, :destroy], Grupo, :status => Grupo.status_inativo, :user_id => user.id
    can :create, Grupo do
      Grupo.count(:conditions => ["user_id = ?", user.id]) < user.plano.num_grupos
    end
    can :ativar_desativar, Grupo, :user_id => user.id
  end

end