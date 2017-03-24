class CommentsController < ApplicationController
  before_action :ensure_that_signed_in, except: [:show]
  before_action :ensure_that_is_moderator, only: [:destroy, :publish, :unpublish]
  before_action :set_comment, only: [:show, :edit, :update, :destroy, :publish, :unpublish]

  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.all
  end

  # GET /comments/1
  # GET /comments/1.json
  def show

    

  end

  # GET /comments/new
  def new

    @comment = Comment.new  
    @comment.idea_id = params[:id]

  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  # POST /comments.json
  def create
    comment = Comment.create params.require(:comment).permit(:time, :text, :idea_id)
    comment.visible=!(comment.idea.moderate?)
    current_user.comments << comment
    
    if comment.idea.moderate
	    redirect_to idea_path(comment.idea), notice: 'Comment will be published after moderation'
    else
	    redirect_to idea_path(comment.idea), notice: 'Comment ws succesfully posted'
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to :controller => 'ideas', :action => 'show', :id => @comment.idea_id, notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def publish
    if @comment.visible != true
      @comment.visible = true
      @comment.save
    end
     redirect_to :controller => 'ideas', :action => 'show', :id => @comment.idea_id
  end

  def unpublish
    if @comment.visible != false
      @comment.visible = false
      @comment.save
    end
     redirect_to :controller => 'ideas', :action => 'show', :id => @comment.idea_id
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:user_id, :time, :text, :idea_id)
    end
end
