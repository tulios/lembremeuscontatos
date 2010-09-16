class Ability
  include CanCan::Ability
  
  def initialize user
    can :destroy, Contato, :user_id => user.id
    can [:edit, :update, :destroy], Grupo, :status => Grupo.status_inativo, :user_id => user.id
  end

end