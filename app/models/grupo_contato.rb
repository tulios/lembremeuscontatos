class GrupoContato < ActiveRecord::Base
  belongs_to :grupo
  belongs_to :contato

  validates_presence_of :grupo_id, :contato_id
end
