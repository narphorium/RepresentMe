class CreateRepresentativeVotes < ActiveRecord::Migration
  def self.up
    create_table :representative_votes, :id => false do |t|
      t.column :vote_id, :integer, :null => false
      t.column :representative_id, :string, :null => false
      t.column :name, :string
      t.column :title, :string
      t.column :date, :datetime
      t.column :vote_type, :string
      t.column :choice, :string
    end
    
    add_index :representative_votes, [:vote_id, :representative_id], :name => "primary key", :unique => true
  end

  def self.down
    drop_table :representative_votes
  end
end
