class User < TwitterAuth::GenericUser
  # Extend and define your user model as you see fit.
  # All of the authentication logic is handled by the
  # parent TwitterAuth::GenericUser class.
  
  alias_column :original => 'name', :new => 'nome'
  
  belongs_to :plano
  
  def folder_name
    "#{self.twitter_id}-#{self.login}"
  end
     
  def finalizar_cadastro!
    configurar_mailchimp_folder!
    configurar_plano!
    self.save!
  end
  
  def cadastro_completo?
    self.folder_id and self.plano
  end
  
  private
  def configurar_plano!
    self.plano = Plano.gratuito unless self.plano
  end
  
  def configurar_mailchimp_folder!
    if Rails.env.test?
      self.folder_id = 1
      return
    end
    
    mailchimp_folder_id = Hominid::Loader.instance.folder_exist? self.folder_name
    
    unless mailchimp_folder_id
      self.folder_id = Hominid::Loader.instance.create_folder(self.folder_name)
    else
      self.folder_id = mailchimp_folder_id
    end
  end
  
end

