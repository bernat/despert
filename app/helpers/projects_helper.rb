module ProjectsHelper
  def project_link(project, opts = {})
    default_opts = {:label => :name}
    opts = default_opts.merge(opts)
    link_to opts[:label] == :name ? project : project.ref, project_task_lists_path(project), :class => "project-label", :style => "background-color:#{project.to_color}"
  end
end
