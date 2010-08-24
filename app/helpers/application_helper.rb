# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  # Recebe um hash {id => methodo}. ex: {:numero => "numeric({allow:'.'})"}
  def alphanumeric(hash)
    fields = []
    hash.keys.each do |key|
      fields << %Q{
        $("#{'#'+(key.to_s)}").#{hash[key]};
      }
    end

    %Q{
      <script type="text/javascript">
        jQuery(function($){
          $(document).ready(function(){
            #{fields}
          });
        });
      </script>
    }
  end
  
  # Recebe um hash {id => mascara}. ex: {:field_1 => '99/99/9999', :field_2 => '(999) 9999-9999'}
  def mask_fields(hash)
    fields = []
    hash.keys.each do |key|
      fields << %Q{
        $("#{'#'+(key.to_s)}").mask("#{hash[key]}");
      }
    end

    %Q{
      <script type="text/javascript">
        jQuery(function($){
          $(document).ready(function(){
            #{fields}
          });
        });
      </script>
    }
  end    
  
end
