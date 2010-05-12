# -*- coding: undecided -*-
require 'redmine'

Redmine::Plugin.register :redmine_estimated_summary do
  name 'Redmine Estimated Summary plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  menu :project_menu,
       :estimated_summary,
        {:controller => 'estimatedsummary',
         :action => 'index'},
       :caption => "工数",
       :last => true,
       :param => :project_id
  permission :view_estimated_summary, { :estimatedsummary => [ :index ] }
end
