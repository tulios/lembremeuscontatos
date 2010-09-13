class Users::GruposController < Users::MainController
  include LembreMeusContatos::Converters
          
  before_filter :verificar_ativos, :only => [:edit, :update, :destroy]
  
  def index
    @grupos = Grupo.pesquisar(
      :page => params[:page],
      :conditions => ["user_id = ?", current_user.id],
      :order => "created_at desc"
    )
  end
  
  def new
    flash[:notice] = t("app.grupo.msg.sucesso")
    redirect_to :action => :index
    return
    @grupo = Grupo.new
  end             
  
  def create           
    @grupo = Grupo.new params[:grupo]
    @grupo.user = current_user
    
    unless @grupo.save
      render :action => :new
      return
    end     
             
    associar_contatos
    @grupo.adicionar_segmentos
    
    flash[:notice] = t("app.grupo.msg.sucesso")
    redirect_to :action => :index
  end
  
  def edit
    @grupo ||= Grupo.find params[:id]
  end
  
  def update
    @grupo ||= Grupo.find params[:id]
    
    unless @grupo.update_attributes(params[:grupo])
      render :action => :edit
      return
    end
    
    associar_contatos
    @grupo.adicionar_segmentos
    
    flash[:notice] = t("app.grupo.msg.atualizado")
    redirect_to :action => :index
  end
  
  def show
    @grupo = Grupo.find params[:id]
    @inicio_minimo = date_format(Grupo.inicio_minimo)
  end

  def destroy
    @grupo ||= Grupo.find params[:id]
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
  
  def verificar_ativos
    @grupo = Grupo.find params[:id]
    raise LembreMeusContatos::Exceptions::BadBehavior, t("app.exceptions.bad_behavior") if @grupo.ativo?
  end
  
end

















