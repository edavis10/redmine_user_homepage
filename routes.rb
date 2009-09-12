# Remap home to use user_homepages but give welcome a high presedence
# route, otherwise it will never map and cause a redirect loop
home '', :controller => 'user_homepages', :action => 'show'
connect 'welcome', :controller => 'welcome'
