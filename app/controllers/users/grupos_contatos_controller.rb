class Users::GruposContatosController < Users::MainController
  
  def destroy
    @grupo_contato = GrupoContato.find params[:id]
    @grupo_contato.destroy
    render :nothing => true
  end
  
end