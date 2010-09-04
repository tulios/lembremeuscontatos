class CreatePlanos < ActiveRecord::Migration
  def self.up
    create_table :planos do |t|
      t.string :nome
      t.integer :num_contatos
      t.integer :num_grupos
      t.integer :periodicidade_min

      t.timestamps
    end

    change_table :users do |t|
      t.belongs_to :plano
    end
  end

  def self.down
    drop_table :planos

    change_table :users do |t|
      t.remove_belongs_to :plano
    end
  end
end

