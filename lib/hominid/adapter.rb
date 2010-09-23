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
    
    def find_campaign
      return nil if Rails.env.test?
      return nil unless self.campaign_id
      Hominid::Loader.instance.find_campaign(self.campaign_id)
    end
       
    def add_or_update_campaign
      campaign = find_campaign
                      
      if campaign.nil?
        self.campaign_id = Hominid::Loader.instance.create_campaign({
          :subject => self.subject,
          :title => self.campaign_title,
          :from_name => self.name,
          :content => self.content,
          :folder_id => self.folder_id
        })
        self.save!
        
      elsif campaign['status'] != 'sent' and campaign['status'] != 'schedule'
        Hominid::Loader.instance.update_campaign(self.campaign_id, "subject", self.subject)
        Hominid::Loader.instance.update_campaign(self.campaign_id, "content", {:html_content => self.content})
      end
    end
    
    def add_segment
      emails_for_segmentation = self.emails
      if emails_for_segmentation and (not emails_for_segmentation.empty?)
        Hominid::Loader.instance.create_segment(self.campaign_id, emails_for_segmentation) unless Rails.env.test?
      end
    end
    
    def segments_correct?                              
      return true if Rails.env.test?
      Hominid::Loader.instance.segment_test self.emails
    end  
    
    def remove_campaign
      return true if Rails.env.test?
      Hominid::Loader.instance.remove_campaign(self.campaign_id)
    end                 
    
    def schedule_campaign
      return true if Rails.env.test?
      Hominid::Loader.instance.schedule_campaign(self.campaign_id, self.start_date)
    end                
    
    def unschedule_campaign
      return true if Rails.env.test?
      Hominid::Loader.instance.unschedule_campaign(self.campaign_id)
    end
    
    module ClassMethods
      
      # Configure the object host
      #
      def sync_with_hominid_list
        unless Rails.env.test?
          self.send :after_save, :add_contact
          self.send :after_destroy, :remove_contact
        end
      end
      
      def sync_with_hominid_campaign
        unless Rails.env.test?
          self.send :after_save, :add_or_update_campaign
          self.send :after_destroy, :remove_campaign
        end
      end
      
    end
    
  end
  
end










































