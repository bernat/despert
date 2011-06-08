class MessagesController < ApplicationController
  load_resource :project, :find_by => :ref
  authorize_resource :project
  load_and_authorize_resource :message, :through => :project
  layout 'project'

  def index
    # Cancan load resource returns multiple instances because of an internal
    # joins, I suppose, further investigation required.
    @messages = @messages.uniq
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @message }
    end
  end

  def new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @message }
    end
  end

  def create
    @message.user = current_user
    @message.author = current_user.name

    respond_to do |format|
      if @message.save
        flash[:notice] = "Missatge creat correctament."
        format.html { redirect_to [@project, @message] }
        format.xml  { render :xml => @message, :status => :created, :location => [@project, @message] }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @message.destroy
    flash[:notice] = "Missatge eliminat correctament."
    respond_to do |format|
      format.html { redirect_to project_messages_url(@project) }
      format.xml  { head :ok }
    end
  end
end

