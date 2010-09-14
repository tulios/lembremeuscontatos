class HomeController < ApplicationController

  def index

    if logged_in?

      if not current_user.nil? and current_user.plano.nil?
        #Adiciona o plano gratuito na mão
        current_user.plano = Plano.find_by_nome("Plano Gratuito")
        current_user.save!
      end

      redirect_to :controller => "users/dashboard"
      return
    end

  end

end

