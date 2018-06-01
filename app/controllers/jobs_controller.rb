class JobsController < ApplicationController
  before_action :set_job, only: [ :edit, :update, :destroy]

  before_action :category_params, only: [:index]

  before_action :authenticate_user!, except: [:index, :show]

  # GET /jobs
  # GET /jobs.json
  def index
    @job = current_user.jobs.new
    @categories = Category.all.map{|c| [ c.name, c.id ] }
    if params[:category].blank?
      @jobs = Job.all.sorted.with_tag(params[:tag])
    else
      @category_id = category_params.id
      @jobs = Job.where(:category_id => @category_id).sorted.with_tag(params[:tag])
    end

  end

  # GET /jobs/1
  # GET /jobs/1.json
  def show
    @job = Job.find(params[:id])
  end

  # GET /jobs/new
  def new
    @job = current_user.jobs.new
    @categories = Category.all.map{|c| [ c.name, c.id ] }
  end

  # GET /jobs/1/edit
  def edit
    @categories = Category.all.map{|c| [ c.name, c.id ] }
  end

  # POST /jobs
  # POST /jobs.json
  def create
    @job = current_user.jobs.new(job_params)
    @job.category_id = params[:category_id]


    respond_to do |format|
      if @job.save
        format.html { redirect_to @job, notice: 'Job was successfully created.' }
        format.json { render :show, status: :created, location: @job }
      else
        format.html { render :new }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /jobs/1
  # PATCH/PUT /jobs/1.json
  def update
    @job.category_id = params[:category_id]
    respond_to do |format|
      if @job.update(job_params)
        format.html { redirect_to @job, notice: 'Job was successfully updated.' }
        format.json { render :show, status: :ok, location: @job }
      else
        format.html { render :edit }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jobs/1
  # DELETE /jobs/1.json
  def destroy
    @job.destroy
    respond_to do |format|
      format.html { redirect_to jobs_url, notice: 'Job was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job
      @job = current_user.jobs.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def job_params
      params.require(:job).permit(:title, :description, :category_id, :user_id, :tag_list)
    end

    def category_params
      Category.find_by(name: params[:category])
    end
end
