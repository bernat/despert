class ProjectTypesController < ApplicationController
  load_and_authorize_resource

  # GET /project_types
  # GET /project_types.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @types }
    end
  end

  # GET /project_types/1
  # GET /project_types/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @type }
    end
  end

  # GET /project_types/new
  # GET /project_types/new.xml
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @type }
    end
  end

  # GET /project_types/1/edit
  def edit
  end

  # POST /project_types
  # POST /project_types.xml
  def create
    respond_to do |format|
      if @project_type.save
        format.html { redirect_to(@project_type, :notice => "L'estat ha estat creat correctament") }
        format.xml  { render :xml => @project_type, :status => :created, :location => @project_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @project_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /project_types/1
  # PUT /project_types/1.xml
  def update
    respond_to do |format|
      if @project_type.update_attributes(params[:project_type])
        format.html { redirect_to(@project_type, :notice => "L'estat s'ha actualitzat correctament") }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /project_types/1
  # DELETE /project_types/1.xml
  def destroy
    respond_to do |format|
      if not @project_type.projects.empty?
        format.html { redirect_to(project_types_url, :alert => "Cannot delete an type with projects associated") }
        format.xml  { render :xml => "error", :status => :unprocessable_entity }
      else
        @project_type.destroy
        format.html { redirect_to(project_types_url) }
        format.xml  { head :ok }
      end
    end
  end
end
