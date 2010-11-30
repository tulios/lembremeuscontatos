class Alter2Grupos < ActiveRecord::Migration
  def self.up
    Grupo.update_all "qtd_envios = 0"
    Grupo.update_all "qtd_enviada = 0"
    Grupo.update_all "total_envios = 0"
  end

  def self.down
  end
end
