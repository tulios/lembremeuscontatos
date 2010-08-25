class Users::GruposController < Users::MainController
  
  def index
    @grupos = Grupo.all
  end
  
  def new
    @grupo = Grupo.new
  end             
  
  def create           
    @grupo = Grupo.new params[:grupo]
    @grupo.user = current_user
    
    unless @grupo.save
      render :action => :new
      return
    end     
    
    flash[:notice] = t("app.grupo.msg.sucesso")
    redirect_to :action => :index
  end
  
  def edit
    @grupo = Grupo.find params[:id]
  end
  
  def update
    @grupo = Grupo.find params[:id]
    
    unless @grupo.update_attributes(params[:grupo])
      render :action => :edit
      return
    end
    
    associar_contatos
    
    flash[:notice] = t("app.grupo.msg.atualizado")
    redirect_to :action => :index
  end
  
  def show
    @grupo = Grupo.find params[:id]
  end

  def destroy
    @grupo = Grupo.find params[:id]
    @grupo.destroy
    
    redirect_to :action => :index
  end
   
  private
  def associar_contatos
    if params[:contatos]
      Contato.find(params[:contatos]).each do |contato|
        GrupoContato.create(:grupo => @grupo, :contato => contato) unless @grupo.contatos.member? contato
      end                
    end                   
  end
  
end

















