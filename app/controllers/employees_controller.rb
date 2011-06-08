class EmployeesController < ApplicationController
  load_resource :find_by => :username
  authorize_resource

  def index
    @employees = @employees.group_by{ |x| x.role }
  end

  def new
  end

  def create
    if @employee.save
      flash[:notice] = "Compte creat"
      redirect_back_or_default employees_url
    else
      render :action => 'new'
    end
  end

  def show
    @last_tasks = @employee.tasks.latest_completed.limit(30)
    i = 19
    @last_hours = []
    while i >= 0
      @last_hours << @employee.tasks.where("date(completed_at) = ?", Date.today - i).sum('duration')
      i = i - 1
    end

    @events = @employee.events.includes([ :background, :subject, :context, :actor ]).limit(100)
    @events = Event.prepare_for_view(@events)
  end

  def edit
  end

  def update
    if @employee.update_attributes(params[:employee])
      flash[:notice] = "Compte actualitzat"
      redirect_to @employee
    else
      render :action => 'edit'
    end
  end

  def destroy
    flash[:notice] = "Usuari #{@employee} esborrat del sistema"
    @employee.destroy
    redirect_to employees_url
  end

  def work_load
    @employee = Employee.find params[:id]
    @planned_tasks = @employee.tasks.includes([{ :task_list => {:project => :project_type }}, :employee, :author]).planned
    @planned_tasks = @planned_tasks.group_by{|x| x.task_list.milestone}
  end
end

