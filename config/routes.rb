ActionController::Routing::Routes.draw do |map|

  Jammit::Routes.draw(map)
  
  map.namespace(:users) do |user|
    user.resources :dashboard, :only => :index
    
    user.pelo_nome '/contatos/pelo_nome', :controller => :contatos, :action => :pelo_nome
    user.resources :contatos
    user.load_contatos_ajax 'contatos_ajax', :controller => :contatos, :action => :index_ajax
                       
    user.resources :grupos do |grupo|
      grupo.resources :grupos_contatos, :only => :destroy, :as => "contatos"
      grupo.resources :agendamento, :only => [:create, :destroy]
    end
  end
  
  map.root :controller => :home

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
