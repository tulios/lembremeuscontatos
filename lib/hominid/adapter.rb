module Hominid
  
  module Adapter
                                                 
    def self.included(klass)
      klass.extend ClassMethods
    end
                             
    # Add a new member in mail chimp list
    #
    def add_contact
      params = {}
    
      if self.name
        f = self.name.split(/\s+/) if self.name
        params[:FNAME] = f[0] if f and f[0]
        params[:LNAME] = f[1..f.length].join(" ") if f and f[1]
      end

      Hominid::Loader.instance.subscribe self.email, params unless defined? @prevent_subscribe
    end
    
    # Remove a member of mail chimp list
    #
    def remove_contact
      Hominid::Loader.instance.unsubscribe self.email unless defined? @prevent_unsubscribe
    end
       
    # Add a new campaign
    #
    def add_campaign
      unless self.campaign_id
        self.campaign_id = Hominid::Loader.instance.create_campaign({
          :subject => self.subject,
          :from_name => self.name,
          :content => self.content,
          :folder_id => self.folder_id
        })
        self.save!
      end
    end  
    
    def remove_campaign                               
      Hominid::Loader.instance.remove_campaign(self.campaign_id)
    end   
    
    module ClassMethods
      
      # Configure the object host
      #
      def sync_with_hominid_list
        self.send :after_save, :add_contact
        self.send :after_destroy, :remove_contact
      end
      
      def sync_with_hominid_campaign
        self.send :after_save, :add_campaign
        self.send :after_destroy, :remove_campaign
      end
      
    end
    
  end
  
end










































