class Users::DashboardController < Users::MainController
  
  before_filter :ajustar_conta_inicial

  def index
    @qtd_contatos ||= Contato.count :conditions => ["user_id = ?", current_user.id]
    @qtd_grupos ||= Grupo.count :conditions => ["user_id = ?", current_user.id]
  end

  private

  def ajustar_conta_inicial
    current_user.finalizar_cadastro! unless current_user.cadastro_completo?
  end

end

