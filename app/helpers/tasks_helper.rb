module TasksHelper
  def menu_sheet

    @menu_sheet = "<div class=\"menup\">\n<ul>\n<li><a href=\"features\"><span>Backlog</span></a></li>\n"
    Sprint.all(:order => "start DESC").each do |sprint|
      if @sprint_name == sprint.name
         @menu_sheet << "<li class=\"current\">\n"
      else
         @menu_sheet << "<li>\n"
      end
      @menu_sheet << link_to(content_tag(:span, sprint.name), :controller => "tasks", :action => "index", :sprint_id => sprint.id)
      @menu_sheet << "</li>"
    end
    @menu_sheet << "<li><a href=\"sprints\"><span>Configuration</span></a></li>\n</ul>\n</div>"

  end
end


