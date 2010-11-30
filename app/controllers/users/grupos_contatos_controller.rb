class Users::GruposContatosController < Users::MainController
             
  before_filter :verificar_permissoes
  
  def destroy
    @grupo_contato ||= GrupoContato.find params[:id]
    @grupo_contato.destroy
    render :nothing => true
  end
  
  private
  def verificar_permissoes
    @grupo_contato = GrupoContato.find params[:id]
    authorize! :destroy, @grupo_contato
  end
  
end