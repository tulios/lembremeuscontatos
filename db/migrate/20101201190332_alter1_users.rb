class Alter1Users < ActiveRecord::Migration
  def self.up
    change_table User.table_name do |t|
      t.integer :grouping_id
    end
  end

  def self.down
    change_table User.table_name do |t|
      t.remove :grouping_id
    end
  end
end
