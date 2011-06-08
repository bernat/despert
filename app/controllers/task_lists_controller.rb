class TaskListsController < ApplicationController
  load_resource :project, :find_by => :ref
  authorize_resource :project
  load_and_authorize_resource :task_list, :through => :project, :except => [:reorder_task, :completed_tasks]

  layout 'project'

  def index
    t = TaskList.arel_table
    @unassigned = @task_lists.where(:name => "unassigned").first
    @archived_task_lists = @task_lists.archived.uniq
    @task_lists = @task_lists.unarchived.includes([ { :tasks => [:employee, :author] }, :group, :milestone ]).where(t[:name].not_eq("unassigned")).uniq

    @task_lists.sort! do |a,b|
      if a.milestone.nil? && b.milestone.nil?
        a.updated_at <=> b.updated_at
      elsif a.milestone.present? && b.milestone.present?
        a.milestone.finishes_at <=> b.milestone.finishes_at
      else
        a.milestone ? -1 : 1
      end
    end

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @closed_tasks = @task_list.tasks.closed
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @task_list }
      format.js
    end
  end

  def new
    @milestone_id = params[:milestone_id] if params[:milestone_id]
    render :layout => "no-layout"
  end

  def create
    respond_to do |format|
      if @task_list.save
        flash[:notice] = "Llista de tasques creada."
        format.html { redirect_to project_task_lists_path(@project) }
        format.xml  { render :xml => @task_list, :status => :created, :location => @task_list }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @task_list.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @task_list.update_attributes(params[:task_list])
        flash[:notice] = "Llista de tasques actualitzada correctament."
        format.html { redirect_to [@project, @task_list] }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @task_list.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @task_list.destroy

    flash[:notice] = "Llista de tasques destruida correctament."

    respond_to do |format|
       format.html { redirect_to project_task_lists_path(@project) }
     end
  end

  def toggle_archive
    @task_list.toggle_archive

    respond_to do |format|
      if @task_list.save
        format.html {redirect_to project_task_lists_path(@task_list.project)}
      else
        format.html { redirect_to request.env["HTTP_REFERER"], :alert => @task_list.errors.full_messages }
      end
    end
  end

  def reorder_task
    @task = Task.find params[:from]
    authorize! :reorder, @task

    ## This avoids to process a call that shouldn't be done from the sortable
    ## jquery setup, but I was unable to avoided otherwise.
    if params[:from_task_list] == params[:to_task_list] && params[:cuca] != "nohay"
      render :status => :unprocessable_entity, :nothing => true
      return
    end

    @to_task_list = TaskList.find params[:to_task_list]
    @to_task = Task.find_by_id params[:to]

    @task.move_to(@to_task_list, @to_task)

    respond_to do |format|
      @task.save

      format.js
    end
  end

  def completed_tasks
    @task_list = @project.task_lists.find params[:id]
    authorize! :read, @task_list

    @tasks = @task_list.tasks.completed

    respond_to do |format|
      format.js
    end
  end
end
