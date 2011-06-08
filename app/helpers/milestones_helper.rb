module MilestonesHelper
  def fill_calendar_info_with_milestones(milestones, global=false)
    info = {}
    milestones.each do |milestone|
      if milestone.completed?
        completed = "completed"
        action = link_to image_tag("reopen10.png", :class => "action-img"),
          toggle_project_milestone_path(milestone.project, milestone),
          :remote => true, :class => "toggle-link",
          :confirm => "Estàs convençut?",
          :id => "toggle-link-#{milestone.id}"
      else
        completed = ""
        action = link_to image_tag("approve10.png", :class => "action-img"),
          toggle_project_milestone_path(milestone.project, milestone),
          :remote => true,
          :id => "toggle-link-#{milestone.id}"
      end
      edit = link_to image_tag("editicon10.png", :class => "action-img"),
        edit_project_milestone_path(milestone.project, milestone),
        :rel => "facebox",
        :class => completed
      delete = link_to image_tag("deleteicon10.png", :class => "action-img"),
        [milestone.project, milestone],
        :confirm => 'Segur?',
        :method => :delete

      link = link_to milestone.name + " (#{milestone.planned_duration.to_i}h)",
        [milestone.project, milestone],
        :id => "milestone-link-#{milestone.id}",
        :class => completed
      if global
        projlink = link_to milestone.project.ref, milestone.project,
          :class => "project-label",
          :style => "background-color:#{milestone.project.to_color};"
      end
      date = milestone.finishes_at
      info[date] ||= []
      info[date] << projlink if global
      if can? :update, milestone
        info[date] << action
        info[date] << edit
        info[date] << delete
      end
      info[date] << link
    end
    info
  end
end
