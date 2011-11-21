module ApplicationHelper
  def main_menu(current)
    content_tag :div, :class => "menup" do
      content_tag :ul do
        content_tag :li do
          content_tag :a, :href => ((current=="features")?"#":"features") do
            content_tag :span, "Backlog"
          end
        end
        Sprint.all(:order => "start DESC").each do |srpint|
          content_tag :li
        end

      end

    end
#    <ul>
#        <li><a href="features"><span>Backlog</span></a></li>
#      <% Sprint.all(:order => "start DESC").each do |sprint| %>
#        <li><%= link_to content_tag(:span, sprint.name), :controller => "tasks", :action => "index", :sprint_id => sprint.id %></li>
#      <% end %>
#        <li class="current"><a href="#"><span>Configuration</span></a></li>
#    </ul>
#</div>
#<div class="menup">
#    <ul>
#        <li><a href="sprints"><span>Sprints</span></a></li>
#        <li><a href="owners"><span>Owners</span></a></li>
#        <li><a href="locations"><span>Locations</span></a></li>
#        <li class="current"><a href="#"><span>Projects</span></li>
#    </ul>
#</div>
  end

  def add_tag (help, url_params)
    url_params[:action] = "new"
    link_to image_tag("/images/add.png") + content_tag(:span, help), url_params, :class => 'info'
  end

  def new_tag (help, url_params = {})
    url_params[:action] = "new"
    link_to image_tag("/images/new.png") + content_tag(:span, help), url_params, :class => 'info'
  end

  def pencil_tag (help, url_params )
    url_params[:action] = "edit"
    link_to image_tag("/images/pencil.png") + content_tag(:span, help), url_params, :class => "info"
  end

  def eye_tag (help, url_params)
    url_params[:action] = "show"
    link_to image_tag("/images/eye.png") + content_tag(:span, help), url_params, :class => "info"
  end

  def delete_tag (help, id)
    link_to image_tag("/images/cancel.png") + content_tag(:span, help),
            id, :confirm => 'Are you sure?', :method => :delete, :class => "info"
  end

end
