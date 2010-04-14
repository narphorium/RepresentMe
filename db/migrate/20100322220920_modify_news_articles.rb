class ModifyNewsArticles < ActiveRecord::Migration
  def self.up
    remove_column :news_articles, :body
    add_index :news_articles, :url, :name => "url index"
    change_column :news_articles, :date, :datetime
  end

  def self.down
  end
end
