# Carregando patches armazenados em lib/patches
Dir[File.join(Rails.root, 'lib', 'patches', '**', '*.rb')].sort.each { |patch| require(patch) }
                  
# Carregando novos modulos armazenados em lib
Dir[File.join(Rails.root, 'lib', 'lembre_meus_contatos', '**', '*.rb')].sort.each { |modulo| require(modulo) }
Dir[File.join(Rails.root, 'lib', 'hominid_loader', '**', '*.rb')].sort.each { |modulo| require(modulo) }

ActiveRecord::Base.send(:extend, LembreMeusContatos::ActiveRecordExtension)

Hominid::Loader.init