module Hominid
  class Instance
    attr_reader :base
                
    def self.get
      @instance ||= Hominid::Instance.new
    end            
                                                                         
    def initialize
      @base = Hominid::Base.new({:api_key => Hominid::Loader.config[:api]})
      @list_id = Hominid::Loader.config[:list_id]
    end
    
    def list
      @list ||= base.find_list_by_id @list_id
    end
            
    def info email
      base.member_info @list_id, email
    end
    
    def subscribe email, params = {}
      params[:FNAME] ||= ""
      params[:LNAME] ||= ""
      base.subscribe(@list_id, email, params)
    end

    def unsubscribe email                      
      base.unsubscribe(@list_id, email)
    end
            
    def create_folder name
      base.create_folder name
    end
    
    def list_folders
      base.folders
    end
    
    def folder_exist? folder_name
      detected = list_folders.select {|folder| folder["name"] == folder_name}
      detected.blank? ? false : detected[0]["folder_id"]
    end
                                   
    # Params:
    #   :subject => String - Obligatory
    #   :from_name => String - Obligatory
    #   :content => String - Obligatory
    #   :folder_id => Integer - Obligatory
    #
    # Return:
    #   The ID for the created campaign
    #
    def create_campaign params = {}
      options = {
        :list_id => @list_id,
        :folder_id => params[:folder_id],
        :from_email => Hominid::Loader.config[:from_email],
        :to_email => Hominid::Loader.config[:to_email],
        :from_name => params[:from_name],
        :subject => params[:subject],
        :template_id => Hominid::Loader.config[:template_id]
      }
      content = {
        :html_content => params[:content]
      }
      base.create_campaign(options, content)
    end
    
    def remove_campaign campaign_id
      base.delete_campaign campaign_id
    end
    
    def update_campaign campaign_id, name, value
      base.update campaign_id, name, value
    end                                   
    
    def find_campaign campaign_id
      base.find_campaign_by_id campaign_id
    end
    
    def create_segment campaign_id, emails
      conditions = create_conditions_array(emails)
      self.update_campaign campaign_id, "segment_opts", {
        :match => "any",
        :conditions => conditions
      }
    end
    
    def segment_test emails           
      conditions = create_conditions_array(emails)
      
      total = base.segment_test @list_id, {
        :match => "any",
        :conditions => conditions
      }
      
      total == emails.length
    end          
    
    def schedule_campaign campaign_id, time
      base.schedule_campaign campaign_id, "#{time}"
    end
    
    def unschedule_campaign campaign_id
      base.unschedule campaign_id
    end
    
    def replicate_campaign campaign_id
      base.replicate campaign_id
    end
    
    def delete_campaign campaign_id
      base.delete campaign_id
    end
    
    private
    
    def create_conditions_array emails
      emails.collect {|email| {:field => "merge0", :op => "eq", :value => email}} 
    end
    
  end
end



































