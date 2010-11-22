class Alter1Grupos < ActiveRecord::Migration
  def self.up
    change_table Grupo.table_name do |t|
      t.integer :qtd_envios  # Quantidade de envios até a inativação
      t.integer :qtd_enviada # Quantidade ja enviada (com base em qtd_envios)
      t.integer :total_envios # Numero incremental de envios, contador
    end
  end

  def self.down
    change_table Grupo.table_name do |t|
      t.remove :qtd_envios
      t.remove :qtd_enviada
      t.remove :total_envios
    end
  end
end
