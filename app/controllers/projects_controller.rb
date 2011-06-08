class ProjectsController < ApplicationController
  load_resource :find_by => :ref, :except => [:list, :list_events, :show]
  authorize_resource
  layout 'project', :except => [:index, :new]

  EVENTS_PER_PAGE = 25 # how many events of a project are displayed

  def activate
    @project.activate!
    redirect_to projects_path
  end

  def show
    @project = Project.includes(:tasks).find_by_ref! params[:id]
    authorize! :read, @project

    #@date = params[:date] ? params[:date].to_date : Date.today
    #@date = @date < Date.today ? @date : Date.today # Que no es passi
    #@last_tasks = @project.last_tasks(@date)

    @events = @project.get_events.limit(100)
    @events = Event.prepare_for_view(@events)

    respond_to do |format|
      format.html
      format.xml { render :xml => @project }
    end
  end

  def new
    respond_to do |format|
      format.html { render :layout => "application" }
      format.xml  { render :xml => @project }
    end
  end

  def create
    respond_to do |format|
      if @project.save
        format.html { redirect_to(@project, :notice => "El projecte s'ha creat amb èxit") }
        format.xml  { render :xml => @project, :status => :created, :location => @project }
      else
        format.html { render :action => :new, :layout => "application" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def index
    @projects = current_user.admin? ? Project.all : current_user.projects
    @projects = @projects.paginate(:per_page => 30, :page => params[:page])

    render :layout => "application"
  end

  def update
    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to(@project, :notice => "El projecte s'ha actualitzat amb èxit") }
        format.json {head :ok}
      else
        format.html { render :action => :edit }
        format.json { render :status => :unprocessable_entity, :nothing => true}
      end
    end
  end

  def destroy
    @project.destroy

    respond_to do |format|
      format.html { redirect_to(projects_url) }
      format.xml  { head :ok }
    end
  end

  def contract
    @lang = params[:lang]
    @client = @project.client
    respond_to do |format|
      format.html { render :layout => "pageable" }
      format.pdf { render :pdf => "Document #{@client.name}", :encoding => "utf-8" }
    end
  end

  def get_roi
    @project = Project.find_by_ref! params[:id]
    authorize! :get_roi, @project

    respond_to do |format|
      begin
        init_date = params[:init_date]
        end_date = params[:end_date]
        @info = @project.get_variable_retribution(init_date, end_date)

        format.js
      rescue
        format.js { render :status => :unprocessable_entity, :nothing => true }
      end
    end
  end
end
