require 'yaml'
require 'twitter'

module Twitter

  module Loader
    def self.init
      Loader.config
      Loader.instance
      RAILS_DEFAULT_LOGGER.info "** TwitterClient Initialized\n"
    end
  
    def self.config environment = Rails.env
      @config ||= {}                               
      path = Rails.root.to_s + '/config/twitter_account.yml'
      @config[environment] ||= YAML.load(File.open(path).read)[environment].symbolize_keys
    end
  
    def self.instance
      unless defined? @twitter_client
        config = Loader.config
        oauth = Twitter::OAuth.new(config[:consumer_token], config[:consumer_secret])
        oauth.authorize_from_access(config[:access_token], config[:access_secret])

        @twitter_client = Twitter::Base.new(oauth)
      end
      @twitter_client
    end
    
  end
  
end