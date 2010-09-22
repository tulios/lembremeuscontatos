desc "Agenda o envio dos grupos"
task :cron => :environment do
  I18n.default_locale = "pt-BR"
  Grupo.agendar_envios!
end