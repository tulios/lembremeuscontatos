class Users::DashboardController < Users::MainController

  before_filter :ajustar_conta_inicial

  def index
    @qtd_contatos ||= Contato.count :conditions => ["user_id = ?", current_user.id]
    @qtd_grupos ||= Grupo.count :conditions => ["user_id = ?", current_user.id]
  end

  private

  def ajustar_conta_inicial
    unless current_user.folder_id or current_user.plano
      
      folder_id = Hominid::Loader.instance.create_folder(current_user.folder_name)
      current_user.folder_id = folder_id

      # Configura o plano
      current_user.plano = Plano.gratuito
      current_user.save!
    end
  end

end

