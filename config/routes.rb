ActionController::Routing::Routes.draw do |map|
  map.with_options :controller => 'estimatedsummary' do |es|
    es.connect 'projects/:project_id/estimatedsummary', :action => 'index'
    es.connect 'projects/:project_id/estimatedsummary/getlist/:key1/:key2', :action => 'getlist'
  end
end
