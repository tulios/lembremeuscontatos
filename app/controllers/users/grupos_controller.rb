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
    
    redirect_to :action => :index
  end
  
end