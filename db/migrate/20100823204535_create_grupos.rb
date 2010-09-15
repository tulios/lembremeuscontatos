class CreateGrupos < ActiveRecord::Migration
  def self.up
    create_table :grupos do |t|
      t.string :nome
      t.text :mensagem
      t.belongs_to :user
      t.integer :periodicidade
      t.date :inicio
      t.date :envio # Data em que a mensagem foi enviada (a primeira eh a data de inicio)
      t.string :campaign_id
      t.string :status
      t.boolean :agendado

      t.timestamps
    end
  end

  def self.down
    drop_table :grupos
  end
end
