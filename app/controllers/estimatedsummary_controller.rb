class EstimatedsummaryController < ApplicationController
  unloadable
  before_filter :find_project

  def createSQL(key1,key2)
    s={}
    s["version"]  = "versions.name"
    s["category"] = "issue_categories.name"
    s["assigned"] = "users.firstname"
    s["priority"] = "enumerations.name"
    s["status"]   = "issue_statuses.name"
    s["tracker"]  = "trackers.name"
    j={}
    j["version"]  = "LEFT JOIN versions ON i.fixed_version_id=versions.id "
    j["category"] = "LEFT JOIN issue_categories ON i.category_id=issue_categories.id "
    j["assigned"] = "LEFT JOIN users ON i.assigned_to_id=users.id "
    j["priority"] = "LEFT JOIN enumerations ON i.priority_id=enumerations.id "
    j["status"]   = ""
    j["tracker"]  = "LEFT JOIN trackers ON i.tracker_id=trackers.id"
    g={}
    g["version"]  = "fixed_version_id"
    g["category"] = "category_id"
    g["assigned"] = "assigned_to_id"
    g["priority"] = "priority_id"
    g["status"]   = "status_id"
    g["tracker"]  = "tracker_id"
    sql = "SELECT "
    sql += s[key1] + " AS n1,"
    sql += s[key2] + " AS n2,"
    sql += " SUM(estimated_hours) AS n3,"
    sql += " SUM(te.hours) AS n4, "
    sql += " SUM(i.done_ratio) AS n5, "
    sql += " COUNT(i.id) AS n6 "
    #sql += " COUNT( CASE WHEN issue_status.is_closed = 1 THEN 1 ELSE 0 END ) AS n6, "
    #sql += " COUNT( CASE WHEN issue_status.is_closed = 0 THEN 1 ELSE 0 END ) AS n7 "
    sql += " FROM issues AS i "
    sql += " LEFT JOIN time_entries AS te ON i.id=te.issue_id "
    sql += " " + j[key1]
    sql += " " + j[key2]
    sql += " LEFT JOIN projects ON i.project_id=projects.id "
    sql += " LEFT JOIN issue_statuses ON i.status_id=issue_statuses.id "
    sql += " WHERE i.project_id=? "
    sql += " AND "
    sql += " i.id NOT IN "
    sql += " (SELECT parent_id  "
    sql += "  FROM issues "
    sql += "  WHERE parent_id>0 "
    sql += "  GROUP BY parent_id "
    sql += " ) "
    sql += " GROUP BY " + g[key1] + "," + g[key2]
  end
  
  def index
    @esurl = url_for
  end

  def getlist
    sql = createSQL(params[:key1],params[:key2])
    list = Issue.find_by_sql([sql,"#{@project.id}"])
    @data = {}
    list.each do |d|
      key = d.n1.nil? ? "none":d.n1
      @data[key] = [] if @data[key]==nil
      @data[key] << d
    end
    case params[:key2]
    when "version"
      @column = l(:field_fixed_version)
    when "category"
      @column = l(:field_category)
    when "assigned"
      @column = l(:field_assigned_to)
    when "priority"
      @column = l(:field_priority)
    when "status"
      @column = l(:field_status)
    when "tracker"
      @column = l(:field_tracker)
    else
      @column = ""
    end
    render :layout => false
  end

  def find_project
    @project = Project.find(params[:project_id])
  end
end
