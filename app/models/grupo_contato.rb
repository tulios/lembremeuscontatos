class GrupoContato < ActiveRecord::Base
  belongs_to :grupo
  belongs_to :contato
end
