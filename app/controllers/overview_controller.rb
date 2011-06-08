class OverviewController < ApplicationController
  def index
    if current_user.admin?
      @milestones = Milestone.marked_uncompleted.limit(20)
    else
      @milestones = current_user.milestones.includes(:project).marked_uncompleted.limit(20)
    end
  end

  def list
    if current_user.admin?
      @events = Event.includes([ :background, :subject, :context, :actor ]).limit(100)
    else
      @events = current_user.viewable_events.limit(100)
    end

    @events = Event.prepare_for_view(@events)

    render :layout => false
  end

  def dashboard
    @projects = current_user.managed_projects.includes(:project_type).running
    @planned_tasks = current_user.tasks.includes([{ :task_list => {:project => :project_type }}, :employee, :author]).planned
    @unplanned_tasks = current_user.tasks.includes([{ :task_list => {:project => :project_type }}, :employee, :author]).unplanned
    @milestones = current_user.milestones.includes(:project => :project_type)

    @planned_tasks = @planned_tasks.group_by{|x| x.task_list.milestone}
  end

  def status_overview
    authorize! :read, :status
    @projects = Project.non_internal.running
    @employees = Employee.all
  end
end

