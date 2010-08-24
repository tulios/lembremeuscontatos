module LembreMeusContatos
  module ActiveRecordExtension
    
    # Obie Fernandes solution for alias ActioveRecord column
  	# link: http://www.jroller.com/obie/entry/some_ar_sugar_4_u
  	# With modifications.
  	#
  	# Ex: alias_column :original => 'emailaddress', :new => 'email
  	#
    def alias_column(params)
      logical_name = params[:new]
      column_name = params[:original]
      
      define_method logical_name do
        @attributes[column_name.to_s]
      end
      
      # Retirado do liferay models
      define_method "#{logical_name}=" do |arg|
        @attributes[column_name.to_s] = arg
      end
    end

  	# Ex: alias_column_method :original => 'emailaddress', :new => 'email
    #
    def alias_column_method(params)
      logical_name = params[:new]
      original_name = params[:original]
      
      define_method logical_name do
        self.send(original_name)
      end                      
      
      define_method "#{logical_name}=" do |arg|
        self.send(original_name, arg)
      end
    end
    
    # Cria um metodo getter e um setter(=) com o sufixo _str, que
    # converte para os formatos de data estabelecidos
    #
    def act_as_virtual_date(*attributes)
    
      attributes.each do |attribute|
        # Setter
        define_method "#{attribute.to_s}_str=" do |arg|
          send("#{attribute.to_s}=", to_date(arg, true))
        end        
        # Getter
        define_method "#{attribute.to_s}_str" do
          date_format send("#{attribute.to_s}")
        end
      end
      
    end
    
  end
end