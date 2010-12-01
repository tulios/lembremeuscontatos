module Hominid
  
  module Adapter
                                                 
    def self.included(klass)
      klass.extend ClassMethods
    end
    
    def instance
      Hominid::Loader.instance
    end
                             
    # Add a new member in mail chimp list
    # Params:
    #   grouping_opt (Hash)
    #
    def add_contact contact = self, grouping_opt = nil
      params = {}
    
      if contact.name
        f = contact.name.split(/\s+/) if contact.name
        params[:FNAME] = f[0] if f and f[0]
        params[:LNAME] = f[1..f.length].join(" ") if f and f[1]
      end
      
      if grouping_opt
        groups = instance.member_groups(contact.email)
        groups << grouping_opt[:groups]
                                  
        params[:GROUPINGS] = []
        params[:GROUPINGS] << {
            :id => grouping_opt[:grouping_id],
            :groups => groups.join(',')
        }
      end

      instance.subscribe contact.email, params unless defined? @prevent_subscribe
    end
    
    # Remove a member of mail chimp list
    #
    def remove_contact
      instance.unsubscribe self.email unless defined? @prevent_unsubscribe
    end
    
    def find_campaign
      return nil if Rails.env.test?
      return nil unless self.campaign_id
      instance.find_campaign(self.campaign_id)
    end
                 
    def create_group
      unless self.grouping_holder.grouping_id
        
        mailchimp_grouping_id = instance.grouping_exist? self.grouping_holder.grouping_name

        unless mailchimp_grouping_id
          self.grouping_holder.grouping_id = instance.create_grouping(self.grouping_holder.grouping_name, [self.subject])
        else
          self.grouping_holder.grouping_id = mailchimp_grouping_id
          instance.create_group(self.subject, self.grouping_holder.grouping_id)
        end            
        self.grouping_holder.save!
        
      else
        instance.create_group(self.subject, self.grouping_holder.grouping_id)
      end
    end   
    
    # Cria ou atualiza uma campanha. Cria ou atualiza um grouping e um grupo.
    #   
    def add_or_update_campaign
      campaign = find_campaign
                      
      if campaign.nil?
        create_group
        
        self.campaign_id = instance.create_campaign({
          :subject => self.subject,
          :title => self.campaign_title,
          :from_name => self.name,
          :content => self.content,
          :folder_id => self.folder_id
        })
        self.save!
        
      elsif campaign['status'] != 'sent' and campaign['status'] != 'schedule'
        if campaign['subject'] != self.subject
          instance.update_group(campaign['subject'], self.subject)
        end
        instance.update_campaign(self.campaign_id, "subject", self.subject)
        instance.update_campaign(self.campaign_id, "content", {:html_content => self.content})
      end
    end
    
    def add_segment contacts = self.contacts, subject = self.subject, grouping_id = self.grouping_holder.grouping_id
      unless contacts.blank?
        grouping_opt = {
          :grouping_id => grouping_id,
          :groups => subject
        }

        contacts.each do |contact|
          add_contact contact, grouping_opt
        end
        
        instance.create_segment_groups(self.campaign_id, grouping_id, [subject])
      end
    end
    
    def segments_correct?                              
      return true if Rails.env.test?
      #instance.segment_test self.emails
      instance.segment_test_group self.grouping_holder.grouping_id, self.subject
    end  
    
    def remove_campaign
      return true if Rails.env.test?
      instance.remove_campaign(self.campaign_id)
      instance.remove_group(self.subject)
    end                 
    
    def schedule_campaign
      return true if Rails.env.test?
      recreate_campaign
      instance.schedule_campaign(self.campaign_id, self.start_date)
    end                
    
    def unschedule_campaign
      return true if Rails.env.test?
      campaign = find_campaign
      if campaign and campaign['status'] == "schedule"
        instance.unschedule_campaign(self.campaign_id)
      end
    end
    
    def replicate_campaign
      new_campaign_id = instance.replicate_campaign(self.campaign_id)
      instance.update_campaign(new_campaign_id, "folder_id", self.folder_id)
      new_campaign_id
    end
    
    def recreate_campaign
      return true if Rails.env.test?
      
      campaign = find_campaign
      
      if campaign['status'] == 'sent'
        
        new_campaign_id = replicate_campaign
        if new_campaign_id
          instance.delete_campaign self.campaign_id
          self.campaign_id = new_campaign_id
          self.save!
          return true
        end
        
      end
      
      false
    end
    
    def unschedule_or_recreate_campaign
      return true if Rails.env.test?
      
      recreate_campaign
      unschedule_campaign
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










































