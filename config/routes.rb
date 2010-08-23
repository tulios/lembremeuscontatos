ActionController::Routing::Routes.draw do |map|
  
  map.namespace(:users) do |user|
    user.resources :dashboard, :only => :index
    user.resources :contatos
    user.load_contatos_ajax 'contatos_ajax', :controller => :contatos, :action => :index_ajax
    user.resources :grupos
  end
  
  map.root :controller => :home

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
