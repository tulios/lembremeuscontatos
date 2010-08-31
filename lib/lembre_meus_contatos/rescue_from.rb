module LembreMeusContatos
  module RescueFrom
  
    def self.included(base)
      base.send(:include, ClassMethods)
    end
  
    module ClassMethods
    
      protected
    
      def tratar_standard_error exception
        output = ""
        output << "\n============================ Erro ============================\n"
        output << "\n\n#{DateTime.now} - Erro inesperado:\n#{exception}\n\n"
        output << "\n============================ /Erro ===========================\n"

        logger.error output
        puts "#{output}\nparams: #{params.inspect}" if Rails.env.test? or Rails.env.development?
      
        render :template => 'errors/standard', :locals => {:error => exception}
      end
      
      def tratar_bad_behavior exception
        output = ""
        output << "\n============================ BadBehavior ============================\n"
        output << "\n\n#{DateTime.now}\n"
        output << "Recurso acessado: #{request.url}\n"
        output << "IP: #{request.remote_ip}\n\n"
        output << "\n============================ /BadBehavior ===========================\n"
        
        logger.error output
        puts "#{output}\nparams: #{params.inspect}" if Rails.env.test? or Rails.env.development?
        
        render :template => 'errors/bad_behavior', :locals => {:error => exception}
      end
    
    end
  
  end
end