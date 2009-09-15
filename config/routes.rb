ActionController::Routing::Routes.draw do |map|
  # Remap home to use user_homepages but give welcome a high presedence
  # route, otherwise it will never map and cause a redirect loop
  map.home '', :controller => 'user_homepages', :action => 'show'
  map.connect 'welcome', :controller => 'welcome'
end
