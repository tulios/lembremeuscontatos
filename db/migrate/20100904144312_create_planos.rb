class CreatePlanos < ActiveRecord::Migration
  def self.up
    create_table :planos do |t|
      t.string :nome
      t.integer :num_contatos
      t.integer :num_grupos
      t.integer :periodicidade_min
    end

    change_table :users do |t|
      t.belongs_to :plano
    end
    
    Plano.create!(:nome => "Gratuito", :num_contatos => 10, :num_grupos => 5, :periodicidade_min => 6)
  end

  def self.down
    drop_table :planos

    change_table :users do |t|
      t.remove_belongs_to :plano
    end
  end
end

