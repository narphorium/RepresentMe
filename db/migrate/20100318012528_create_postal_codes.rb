class CreatePostalCodes < ActiveRecord::Migration
  def self.up
    create_table :postal_codes, :id => false do |t|
      t.column :key, :string, :null => false
      t.column :latitude, :double, :null => false
      t.column :longitude, :double, :null => false
      t.column :neighbourhood, :string
      t.column :municipal_ward, :string
      t.column :provincial_riding, :string
      t.column :federal_riding, :string
      t.column :census_district, :string
    end
    
    add_index :postal_codes, :key, :name => "primary key", :unique => true
  end

  def self.down
    drop_table :postal_codes
  end
end
