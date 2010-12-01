module Hominid
  class Instance
    attr_reader :base
    attr_reader :list_id
                
    def self.get
      @instance ||= Hominid::Instance.new
    end            
                                                                         
    def initialize
      @base = Hominid::Base.new({:api_key => Hominid::Loader.config[:api]})
      @list_id = Hominid::Loader.config[:list_id]
    end
    
    def member_info email
      base.member_info(@list_id, email)
    end
    
    def member_groups email
      member_info(email)["merges"]["GROUPINGS"].map{|e| e["groups"]}
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
    
    def list_groupings
      base.groupings(@list_id)
    end
    
    def folder_exist? folder_name
      detected = list_folders.select {|folder| folder["name"] == folder_name}
      detected.blank? ? false : detected[0]["folder_id"]
    end
    
    def grouping_exist? grouping_name
      detected = list_groupings.select {|grouping| grouping["name"] == grouping_name}
      detected.blank? ? false : detected[0]["id"]
    rescue Hominid::ListError => e # <211> This list does not have interest groups enabled
      false
    end
                            
    # Um grouping eh um agregador de grupos. 1 grouping possui varios grupos
    #
    def create_grouping name, groups_names, type = 'checkboxes'
      base.create_grouping(@list_id, name, type, groups_names) 
    end                        
                            
    def create_group group_name, grouping_id
      base.create_group(@list_id, group_name, grouping_id)
    end                                                  
    
    def update_group old_name, new_name
      base.update_group(@list_id, old_name, new_name)
    end
    
    def remove_group group_name
      base.delete_group(@list_id, group_name)
    end
    
    def find_group grouping_id, group_name
      grouping = list_groupings.select {|grouping| grouping["id"] == grouping_id}
      group = grouping[0]["groups"].select {|group| group["name"] == group_name}
      (group and group.length == 1) ? group[0] : nil
      
    rescue Hominid::ListError => e # <211> This list does not have interest groups enabled
      nil
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
    
    def create_segment_email campaign_id, emails
      conditions = create_conditions_array(emails)
      self.update_campaign campaign_id, "segment_opts", {
        :match => "any",
        :conditions => conditions
      }
    end                     
    
    def create_segment_groups campaign_id, grouping_id, groups_names
      conditions = create_conditions_array_for_groupings(grouping_id, groups_names)
      self.update_campaign campaign_id, "segment_opts", {
        :match => "any",
        :conditions => conditions
      }
    end
    
    def segment_test_email emails           
      conditions = create_conditions_array(emails)
      
      total = base.segment_test @list_id, {
        :match => "any",
        :conditions => conditions
      }
      
      total == emails.length
    end
    
    def segment_test_groups grouping_id, groups_names
      conditions = create_conditions_array_for_groupings(grouping_id, groups_names)
      
      total = base.segment_test @list_id, {
        :match => "any",
        :conditions => conditions
      }
      
      #total == emails.length
      # TODO: Verificar a contagem de emails para ver se vai dar certo
      true
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
                  
    def create_conditions_array_for_groupings grouping_id, groups_names
      field = "interests-#{grouping_id}"
      result = []
      
      groups_names.each do |group_name|
        group = find_group(grouping_id, group_name)
        result << {:field => field, :op => "one", :value => group["name"]} if group
      end
      
      result
    end
    
    def create_conditions_array emails
      emails.collect {|email| {:field => "merge0", :op => "eq", :value => email}} 
    end
    
  end
end



































