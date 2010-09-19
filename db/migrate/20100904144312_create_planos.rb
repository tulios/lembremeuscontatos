class CreatePlanos < ActiveRecord::Migration
  def self.up
    create_table :planos do |t|
      t.string  :nome
      t.integer :num_contatos
      t.integer :num_grupos
      t.integer :periodicidade_min
      t.decimal :preco, :precision => 5, :scale => 2
    end

    change_table :users do |t|
      t.belongs_to :plano
    end
    
    plano = Plano.create!(:nome => "Gratuito", :num_contatos => 30, :num_grupos => 15, :periodicidade_min => 6, :preco => 0)
    User.update_all "plano_id = #{plano.id}"
  end

  def self.down
    drop_table :planos

    change_table :users do |t|
      t.remove_belongs_to :plano
    end
  end
end

