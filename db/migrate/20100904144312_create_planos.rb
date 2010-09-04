class CreatePlanos < ActiveRecord::Migration
  def self.up
    create_table :planos do |t|
      t.belongs_to :users

      t.integer :num_contatos
      t.integer :num_grupos
      t.integer :periodicidade_min

      t.timestamps
    end
  end

  def self.down
    drop_table :planos
  end
end

