class CreateGruposContatos < ActiveRecord::Migration
  def self.up
    create_table :grupos_contatos do |t|
      t.belongs_to :grupo
      t.belongs_to :contato                  
      
      t.timestamps
    end
  end

  def self.down
    drop_table :grupos_contatos
  end
end
