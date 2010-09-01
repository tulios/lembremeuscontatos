module LembreMeusContatos
  module Converters
                   
    protected

    # Currency to float
    #
    def currency_to_number(currency)
      if valid_string?(currency)
        return currency.gsub(/[\.]/, '').gsub(/[,]/, '.').gsub(/[A-Z]/, '').gsub(/[$]/, '').gsub(/[\s]/, '').to_f
      else
        return nil
      end
    end
  
    def date!(string, delimiter = '/')
      begin
          return string_to_datetime(string, delimiter, true) # workaround
      rescue
        return nil
      end

      return nil
    end

    # String para data
    #
    def to_date(string, just_date = false, delimiter = '/')
      begin
        if just_date
          return string_to_date(string, delimiter)
        else
          return string_to_datetime(string, delimiter)
        end

      rescue
        return nil
      end

      return nil
    end

    # Converte a data string informada e verifica se eh uma data valida
    #
    def date_valid?(string)
      if string and (not string.empty?) 
        # Caso consiga criar a data, eh uma data valida
        return (not to_date(string, true).nil?)
      end      
      false
    end
  
    def empty?(string)
      string.nil? or string.empty?
    end

    def date_format(date)
      if date
       date.strftime("%d/%m/%Y")
      end
    end
  
    def time_format(time)
      if time
       time.strftime("%d/%m/%Y %I:%M %p")
      end
    end

    private
    # Verifica se é uma string
    def string?(string)
      string.class == String
    end
  
    # Verifica se uma string é valida
    def valid_string?(string)
      string and string?(string) and string.length > 0
    end

    # Converte uma string para DateTime
    def string_to_datetime(string, delimiter, workaround = false)

      if valid_string?(string)
        array = string.split(delimiter)
        if workaround
          return DateTime.new(array[2].to_i, array[1].to_i, array[0].to_i, 10, 10)
        end
        return DateTime.new(array[2].to_i, array[1].to_i, array[0].to_i)
      end

      nil

    end
  
    # Converte uma string para Date
    def string_to_date(string, delimiter)

      if valid_string?(string)
        return string.split("/").reverse.join("-").to_date
      end

      nil

    end
  
  end
end



















