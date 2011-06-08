class CommentsController < ApplicationController

  def create
    @commentable = find_commentable
    @comment = @commentable.comments.build(params[:comment])

    if @comment.save
      opts = {:context => @commentable}
      opts[:background] = @commentable.project if @commentable.respond_to?("project")

      flash[:notice] = "Comentari emès"
      respond_to do |format|
        format.html { redirect_to root_url }
        format.js
      end
    else
      flash[:error] = "Error indefinit"
      redirect_to '/'
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @commentable = @comment.commentable
    opts = {:context => @commentable}
    opts[:background] = @commentable.project if @commentable.respond_to?("project")

    @comment.destroy

    respond_to do |format|
      format.html { redirect_to root_url }
      format.js
    end
  end

private
  def find_commentable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end
end

