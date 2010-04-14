ActionController::Routing::Routes.draw do |map|
  map.root :controller => "news"
  
  map.connect '/change_location', :controller => "news", :action => "change_location"
  
  map.connect '/:id', :controller => "news", :action => "view"
  map.connect '/rss/:id.xml', :controller => "news", :action => "rss"
  map.connect '/atom/:id.xml', :controller => "news", :action => "atom"

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
