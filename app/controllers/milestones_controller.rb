class MilestonesController < ApplicationController
  load_resource :project, :find_by => :ref
  authorize_resource :project
  load_and_authorize_resource :milestone, :through => :project, :except => :overview

  layout 'project', :except => :overview

  def index
    @milestones = @milestones.uniq

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def new
    @date = params[:date].presence
    render :layout => "no-layout"
  end

  def show
  end

  def create
    respond_to do |format|
      if @milestone.save
        flash[:notice] = "Milestone creat correctament."
        format.html { redirect_to project_milestones_url(@project) }
        format.xml  { render :xml => @milestone, :status => :created, :location => [@project, @milestone] }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @milestone.errors, :status => :unprocessable_entity }
        format.js
      end
    end
  end

  def edit
    render :layout => "no-layout"
  end

  def update
    respond_to do |format|
      if @milestone.update_attributes(params[:milestone])
        flash[:notice] = "Milestone actualitzat correctament."
        format.html { redirect_to project_milestones_url(@milestone.project) }
        format.xml  { head :ok }
        format.js
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @milestone.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @milestone.destroy
    flash[:notice] = "Milestone eliminat."
    respond_to do |format|
      format.html { redirect_to project_milestones_url(@milestone.project) }
      format.js
      format.xml  { head :ok }
    end
  end

  def toggle
    authorize! :update, @milestone
    @milestone.completed = !@milestone.completed
    @milestone.save
    respond_to do |format|
      format.js
    end
  end

  def overview
    if current_user.admin?
      @milestones = Milestone.includes(:project)
    else
      @milestones = current_user.milestones.includes(:project)
    end

    render :layout => "application"
  end
end
