namespace :db do
	
	namespace :test do
	  
		desc "Executa os arquivo seeds.rb em spec/"
	  task :seed => :environment do |t|
      begin
        load 'spec/seeds.rb'
      rescue => e
        puts "ERRO (db:test:seed): #{e}"
      end
	  end
  	 
  end
  
end