class Users::ContatosController < Users::MainController

  def pelo_nome             
    @contatos = Contato.pesquisar_pelo_nome params[:nome], current_user
    render :json => @contatos
  end
         
  def index
    @contatos = Contato.all
  end
  
  def index_ajax
    @contatos = Contato.all
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
    @contato.destroy
    
    redirect_to :action => :index
  end
  
end