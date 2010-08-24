# Carregando patches armazenados em lib/patches
Dir[File.join(Rails.root, 'lib', 'patches', '**', '*.rb')].sort.each { |patch| require(patch) }
                  
# Carregando novos modulos armazenados em lib
Dir[File.join(Rails.root, 'lib', 'lembre_meus_contatos', '**', '*.rb')].sort.each { |patch| require(patch) }

ActiveRecord::Base.send(:extend, LembreMeusContatos::ActiveRecordExtension)