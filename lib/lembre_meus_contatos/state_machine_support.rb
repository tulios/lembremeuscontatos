module LembreMeusContatos
  module StateMachineSupport
    
    def self.included(klass)
      klass.extend ClassMethods
    end
    
    module ClassMethods 
      # Retorna a representacao do status informado. 
      # Ex: Registro.status :ativo => "ativo"
      #     Registro.status :cancelado => "cancelado"
      #
      # Caso o status ('qual') não seja informado, retorna um array com os status disponíveis.
      # Ex: Registro.status => ["ativo", "cancelado"]
      #
      # Caso o status não seja encontrado retorna nil
      #         
      def status qual = nil
        self.aasm_states.each do |state|
          return state.name.to_s if state.name == qual
        end

        return self.aasm_states.collect{|state| state.name.to_s} if qual.nil?
        nil
      end

      def method_missing(method, *args, &block)      

        # Verifica se o método informado obedece ao padrão 'status_', caso sim pega o restante do
        # nome do método e informada ao método Registro#status.
        # Ex de uso: Registro.status_ativo => "ativo"; seria o mesmo que chamar Registro.status :ativo
        #            Registro.status_cancelado => "cancelado"; seria o mesmo que chamar Registro.status :cancelado
        #            Registro.status_nao_existe => nil
        #
        if method.to_s =~ /^status_(.*)/
          return self.status $1.intern
        end

        super(method, *args, &block)
      end
    end
    
  end
end