class AttachmentsController < ApplicationController
  load_resource :project, :find_by => :ref
  authorize_resource :project
  load_and_authorize_resource :attachment, :through => :project
  layout 'project'

  def index
    @attachments = @attachments.uniq

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @attachments }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @attachment }
    end
  end

  def new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @attachment }
    end
  end

  def create
    @attachment.employee = current_user

    respond_to do |format|
      if @attachment.save
        flash[:notice] = "Arxiu pujat amb èxit."
        format.html { redirect_to project_attachments_url(@project) }
        format.xml  { render :xml => @attachment, :status => :created, :location => [@project, @attachment] }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @attachment.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @attachment.update_attributes(params[:attachment])
        flash[:notice] = "Arxiu actualitzat amb èxit."
        format.html { redirect_to project_attachments_url(@project) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @attachment.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @attachment.destroy
    flash[:notice] = "Arxiu eliminat amb èxit."
    respond_to do |format|
       format.html { redirect_to project_attachments_url(@project) }
       format.xml  { head :ok }
     end
  end
end

