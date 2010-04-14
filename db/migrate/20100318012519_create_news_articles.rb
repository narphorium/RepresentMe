class CreateNewsArticles < ActiveRecord::Migration
  def self.up
    create_table :news_articles do |t|
      t.column :title, :string, :null => false
      t.column :date, :date, :null => false
      t.column :url, :string, :null => false
      t.column :summary, :text
      t.column :body, :string
    end
  end

  def self.down
    drop_table :news_articles
  end
end
