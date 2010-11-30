class Users::GruposController < Users::MainController
  include LembreMeusContatos::Converters
  
  before_filter :verificar_permissao_criacao, :only => [:new, :create]
  before_filter :verificar_permissao_atualizacao, :only => [:edit, :update, :destroy]
  before_filter :verificar_permissao_visualizacao, :only => :show
  
  def index
    @grupos = Grupo.pesquisar(
      :page => params[:page],
      :conditions => ["user_id = ?", current_user.id],
      :order => "created_at desc"
    )
  end
  
  def new
    @grupo = Grupo.new
  end             
  
  def create           
    @grupo = Grupo.new params[:grupo]
    @grupo.user = current_user

    ActiveRecord::Base::transaction do
      @grupo.save!
      associar_contatos
      @grupo.adicionar_segmentos
    end

    flash[:notice] = t("app.grupo.msg.sucesso")
    redirect_to :action => :index       
    
  rescue ActiveRecord::ActiveRecordError
    @contatos_temporarios = Contato.find(params[:contatos]) if params[:contatos]
    render :action => :new
  end
  
  def edit
    @grupo ||= Grupo.find params[:id]
  end
  
  def update
    @grupo ||= Grupo.find params[:id]
              
    ActiveRecord::Base::transaction do
      @grupo.update_attributes!(params[:grupo])
      associar_contatos
      @grupo.adicionar_segmentos
    end
    
    flash[:notice] = t("app.grupo.msg.atualizado")
    redirect_to :action => :index
    
  rescue ActiveRecord::ActiveRecordError
    @contatos_temporarios = Contato.find(params[:contatos]) if params[:contatos]
    render :action => :edit
  end
  
  def show
    @grupo ||= Grupo.find params[:id]
    @inicio_minimo = date_format(Grupo.inicio_minimo)
  end

  def destroy
    @grupo ||= Grupo.find params[:id]
    @grupo.destroy
    
    redirect_to :action => :index
  end
  
  private
  def verificar_permissao_criacao
    authorize! :create, Grupo
  end
  
  def verificar_permissao_atualizacao          
    @grupo = Grupo.find params[:id]
    authorize! params[:action].intern, @grupo
  end
  
  def verificar_permissao_visualizacao
    @grupo = Grupo.find params[:id]
    authorize! :show, @grupo
  end
  
  def associar_contatos
    contatos = params[:contatos] ? Contato.find(params[:contatos]) : []
    contatos.each do |contato|
      authorize! :associar, contato
      GrupoContato.create(:grupo => @grupo, :contato => contato) unless @grupo.contatos.member? contato
    end
  end
  
end

















