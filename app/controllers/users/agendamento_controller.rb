class Users::AgendamentoController < Users::MainController 
  
  def create
    @grupo = Grupo.find params[:grupo_id]
    unless @grupo.inativo? and @grupo.ativar!
      render :template => "users/grupos/show"
      return
    end
                
    flash[:notice] = t("app.grupo.msg.agendado", :data => @grupo.inicio_str)
    redirect_to users_grupos_url
  end
  
end