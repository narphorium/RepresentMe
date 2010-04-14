class CreateArticleEntities < ActiveRecord::Migration
  def self.up
    create_table :article_entities, :id => false do |t|
      t.column :article_id, :integer, :null => false
      t.column :entity_id, :string, :null => false
    end
    
    add_index :article_entities, :entity_id, :name => "entities key", :unique => true
  end

  def self.down
    drop_table :article_entities
  end
end
