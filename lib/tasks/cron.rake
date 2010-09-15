desc "Agenda o envio dos grupos"
task :cron => :environment do
  Grupo.agendar_envios!
end