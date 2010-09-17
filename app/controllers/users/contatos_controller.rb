class Users::ContatosController < Users::MainController
  
  before_filter :verificar_permissao_criacao, :only => [:new, :create]
  
  def pelo_nome             
    @contatos = Contato.pesquisar_pelo_nome params[:nome], current_user
    render :json => @contatos
  end
         
  def index
    pesquisar
  end
  
  def index_ajax
    pesquisar
    render :partial => 'users/contatos/list'
  end
  
  def new                 
    @contato = Contato.new
    render :layout => false
  end                                       
  
  def create
    @contato = Contato.new(params[:contato])
    @contato.user = current_user
    
    unless @contato.save
      render :action => :new, :layout => false
      return
    end
    
    render :layout => false
  end
  
  def destroy
    @contato = Contato.find params[:id]
    authorize! :destroy, @contato
    
    @contato.destroy
    redirect_to :action => :index
  end
   
  private
  def verificar_permissao_criacao
    authorize! :create, Contato
  end
  
  def pesquisar
    @contatos = Contato.pesquisar(
      :page => params[:page],
      :conditions => ["user_id = ?", current_user.id],
      :order => "nome asc"
    )
  end
  
end