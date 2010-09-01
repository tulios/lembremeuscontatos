class Users::AgendamentoController < Users::MainController 
  include LembreMeusContatos::Converters
  
  def create
    @grupo = Grupo.find params[:grupo_id]
    @grupo.inicio_str = params[:inicio_str]
    
    unless @grupo.inativo? and @grupo.ativar!
      @inicio_minimo = date_format(Grupo.inicio_minimo)
      render :template => "users/grupos/show"
      return
    end
                
    flash[:notice] = t("app.grupo.msg.agendado", :data => @grupo.inicio_str)
    redirect_to users_grupos_url
  end
  
end