require 'yaml'

module Hominid

  module Loader
    def self.init
      Loader.config
      Loader.instance
      RAILS_DEFAULT_LOGGER.info "** MailChimp Initialized\n"
    end
  
    def self.config environment = Rails.env
      @config ||= {}
      @config[environment] ||= YAML.load(File.open(Rails.root.to_s + '/config/mail_chimp.yml').read)[environment].symbolize_keys
    end
  
    def self.instance
      Hominid::Instance.get
    end
    
    def self.list
      self.instance.list
    end
        
  end
  
end