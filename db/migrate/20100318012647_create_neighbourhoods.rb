class CreateNeighbourhoods < ActiveRecord::Migration
  def self.up
    create_table :neighbourhoods, :id => false do |t|
      t.column :key, :string, :null => false
      t.column :name, :string, :null => false
      t.column :latitude, :double, :null => false
      t.column :longitude, :double, :null => false
      t.column :neighbourhood, :string
      t.column :municipal_ward, :string
      t.column :provincial_riding, :string
      t.column :federal_riding, :string
      t.column :census_district, :string
    end
    
    add_index :neighbourhoods, :key, :name => "primary key", :unique => true
    
  end

  def self.down
    drop_table :neighbourhoods
  end
end
