class IndustryJobsController < ApplicationController
  # GET /industry_jobs
  # GET /industry_jobs.json
  def index
    IndustryJob.api_update(current_user)
    @industry_jobs = IndustryJob.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @industry_jobs }
    end
  end

  # GET /industry_jobs/1
  # GET /industry_jobs/1.json
  def show
    @industry_job = IndustryJob.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @industry_job }
    end
  end

  # GET /industry_jobs/new
  # GET /industry_jobs/new.json
  def new
    @industry_job = IndustryJob.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @industry_job }
    end
  end

  # GET /industry_jobs/1/edit
  def edit
    @industry_job = IndustryJob.find(params[:id])
  end

  # POST /industry_jobs
  # POST /industry_jobs.json
  def create
    @industry_job = IndustryJob.new(params[:industry_job])

    respond_to do |format|
      if @industry_job.save
        format.html { redirect_to @industry_job, notice: 'Industry job was successfully created.' }
        format.json { render json: @industry_job, status: :created, location: @industry_job }
      else
        format.html { render action: "new" }
        format.json { render json: @industry_job.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /industry_jobs/1
  # PUT /industry_jobs/1.json
  def update
    @industry_job = IndustryJob.find(params[:id])

    respond_to do |format|
      if @industry_job.update_attributes(params[:industry_job])
        format.html { redirect_to @industry_job, notice: 'Industry job was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @industry_job.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /industry_jobs/1
  # DELETE /industry_jobs/1.json
  def destroy
    @industry_job = IndustryJob.find(params[:id])
    @industry_job.destroy

    respond_to do |format|
      format.html { redirect_to industry_jobs_url }
      format.json { head :no_content }
    end
  end
end
