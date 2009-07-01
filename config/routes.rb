ActionController::Routing::Routes.draw do |map|
  # restful routes
  map.resources :kills

  # compatible routes
  map.connect 'km/:id', :controller => 'kills', :action => 'show'
  map.connect 'raw/:id', :controller => 'kills', :action => 'raw'

  # search routes
  map.corporation 'corp', :controller => 'kills', :action => 'search', :lookup => 'corporations'
  map.alliance 'alliance', :controller => 'kills', :action => 'search', :lookup => 'alliances'
  map.battle 'battle', :controller => 'kills', :action => 'search', :lookup => 'battles'
  map.search 'search', :controller => 'kills', :action => 'search'

  map.player_search 'player/:query', :controller => 'kills', :action => 'search', :field => 'players', :method => 'route'
  map.corporation_search 'corp/:query', :controller => 'kills', :action => 'search', :field => 'corporations', :method => 'route'
  map.alliance_search 'alliance/:query', :controller => 'kills', :action => 'search', :field => 'alliances', :method => 'route'
  map.ship_search 'ship/:query', :controller => 'kills', :action => 'search', :field => 'ships', :method => 'route'
  map.system_search 'system/:query', :controller => 'kills', :action => 'search', :field => 'solar_system', :method => 'route'
  map.region_search 'region/:query', :controller => 'kills', :action => 'search', :field => 'region', :method => 'route'
  map.today_search 'archive/today', :controller => 'kills', :action => 'search', :query => "date:[#{24.hours.ago.utc.to_i}>", :method => 'route'
  map.yesterday_search 'archive/yesterday', :controller => 'kills', :action => 'search', :query => "date:[#{48.hours.ago.utc.to_i} #{24.hours.ago.utc.to_i}]", :method => 'route'

  # utility routes
  map.error 'error/:code', :controller => 'application', :action => 'error'
  
  # root route
  map.root :controller => 'kills', :action => 'index', :query => '*', :limit => 50, :method => 'route'

  # default routes
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
