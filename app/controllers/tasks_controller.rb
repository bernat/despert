class TasksController < ApplicationController
  load_resource :project, :find_by => :ref, :except => [:archive_toggle, :toggle_task]
  authorize_resource :project
  layout 'project'

  def show
    @task = Task.find(params[:id])
    authorize! :read, @task
    @events = @task.events.paginate(:per_page => 20, :page => params[:page])
    respond_to do |format|
      format.html
      format.js { render :json => @task.to_json }
    end
  end

  def toggle
    @task = Task.find(params[:id])
    authorize! :toggle_task, @task

    @task.toggle

    respond_to do |format|
      if @task.save
        flash[:notice] = "Tasca completada amb èxit"
        format.html { redirect_to request.env["HTTP_REFERER"] || project_task_lists_url(@task.project) }
        format.js
      else
        flash[:notice] = @task.errors.full_messages
        format.html { redirect_to request.env["HTTP_REFERER"] || project_task_lists_url(@task.project) }
        format.js
      end
    end
  end

  def archive_toggle
    @task = Task.find(params[:id])
    authorize! :archive_toggle_task, @task

    @task.archive_toggle

    respond_to do |format|
      if @task.save
        flash[:notice] = "Tasca #{@task.closed ? 'arxivada' : 'desarxivada'} amb èxit"
        format.html { redirect_to request.env["HTTP_REFERER"] || project_task_lists_url(@task.project) }
        format.js
      else
        flash[:notice] = @task.errors.full_messages
        format.html { redirect_to request.env["HTTP_REFERER"] || project_task_lists_url(@task.project) }
        format.js
      end
    end
  end

  def create
    @task_list = TaskList.find(params[:task_list_id])

    v = params[:task].keys.first
    @task = @task_list.tasks.build params[:task].fetch(v)
    authorize! :create, @task

    @task.position = (@task_list.tasks.uncompleted.maximum('position') || 0) + 1
    @task.author = current_user

    @task.toggle if params[:commit] == "Publicar completada"

    respond_to do |format|
      if @task.save
        format.html {
          flash[:notice] = "Tasca creada amb èxit."
          redirect_to @task_list
        }
        format.js
      else
        format.html { render :action => "new" }
        format.js
      end
    end
  end

  def new
    render :layout => 'no-layout'
  end

  def edit
    @task = Task.find(params[:id])
    authorize! :update, @task
    @task_list = @task.task_list
    render :layout => 'no-layout'
  end

  def update
    @task = Task.find(params[:id])
    authorize! :update, @task

    if params[:task][:title].present? || params[:task][:description].present?
      authorize! :edit_task_content, @task
      @task.edit_content(params)
    end
    if params[:task][:employee_id].present?
      authorize! :reassign_user, @task
      @task.reassign_user(params)
    end
    if params[:task][:duration].present?
      authorize! :add_hours, @task
      @task.add_hours(params)
    end
    @task_list = @task.task_list

    if params[:commit] == "Publicar completada"
      authorize! :toggle_task, @task
      @task.toggle
    end

    respond_to do |format|
      if @task.save
        flash[:notice] = "Tasca actualitzada existosament."
        format.html { redirect_to request.env["HTTP_REFERER"] || project_task_lists_url(@task.project) }
        format.js  { head :ok }
      else
        flash[:alert] = "Error a l'actualitzar la tasca"
        format.html { redirect_to request.env["HTTP_REFERER"] || project_task_lists_url(@task.project) }
        format.js  { render :json => @task.errors.to_json, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @task = Task.find(params[:id])
    authorize! :destroy, @task

    @task_list = @task.task_list
    @task.destroy

    respond_to do |format|
      format.html {redirect_to request.env["HTTP_REFERER"] || project_task_lists_url(@task_list.project)}
      format.js
    end
  end
end

