class DiscussionsController < ApplicationController
  before_action :set_discussion, only: [:show, :edit, :update, :destroy, :like, :unlike]

  before_action :authenticate_user!

  # GET /discussions
  # GET /discussions.json
  def index
    @discussions = Discussion.all.sorted
    @discussion = current_user.discussions.new

  end

  # GET /discussions/1
  # GET /discussions/1.json
  def show
    @new_comment  = Comment.build_from(@discussion, current_user.id, "")
  end

  # GET /discussions/new
  # def new
  #   @discussion = current_user.discussions.new
  # end

  # GET /discussions/1/edit
  def edit
  end

  # POST /discussions
  # POST /discussions.json
  def create
    @discussion = current_user.discussions.new(discussion_params)

    respond_to do |format|
      if @discussion.save
        format.html { redirect_to discussions_path, notice: 'Discussion was successfully created.' }
        format.json { render :show, status: :created, location: @discussion }
      else
        format.html { redirect_to discussions_path, alert: 'Discussion not successfully created' }
        format.json { render json: @discussion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /discussions/1
  # PATCH/PUT /discussions/1.json
  def update
    respond_to do |format|
      if @discussion.update(discussion_params)
        format.html { redirect_to @discussion, notice: 'Discussion was successfully updated.' }
        format.json { render :show, status: :ok, location: @discussion }
      else
        format.html { render :edit }
        format.json { render json: @discussion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /discussions/1
  # DELETE /discussions/1.json
  def destroy
    @discussion.destroy
    respond_to do |format|
      format.html { redirect_to discussions_url, notice: 'Discussion was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # POST /discussion/like
  def like
    #@like = @discussion.likes.build(user: current_user)
    if @discussion.likes.create(user: current_user)
    # if @like.save
      flash[:success] = 'Liked'
      redirect_to discussions_path
    else
      flash[:warning] = 'You can\'t like this post'
      redirect_to discussions_path
    end
  end

  def unlike
      discussion.likes.where(user: current_user).destroy_all
      redirect_to discussions_path, :notice => 'Unliked!'
  end

  # def create
  #   if post.likes.create(user: current_user)
  #     redirect_to post_redirect(post), :notice => 'Liked!'
  #   else
  #     redirect_to post_redirect(post), :alert => 'An error prevented you from liking this post!'
  #   end
  # end

  # def destroy
  #   post.likes.where(user: current_user).destroy_all
  #   redirect_to post_redirect(post), :notice => 'Unliked!'
  # end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_discussion
      @discussion = Discussion.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def discussion_params
      params.require(:discussion).permit(:body)
    end


end
