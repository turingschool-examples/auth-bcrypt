class ChangeIntegerForRole < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.change :role, :integer
    end
  end

  def self.down
    change_table :users do |t|
      t.change :role, :string
    end
  end
end
