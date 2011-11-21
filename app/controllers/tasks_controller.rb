class TasksController < ApplicationController

  before_filter :find_sprint

  # GET /tasks
  # GET /tasks.xml
  def index
    @sprint_name = @sprint.name
    # @features = Feature.where(:sprint_id => @sprint.id)

    @sprint.info_sprint

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tasks }
    end
  end

  # GET /tasks/1
  # GET /tasks/1.xml
  def show
    @task = Task.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @task }
    end
  end

  # GET /tasks/new
  # GET /tasks/new.xml
  def new
    @task = Task.new
    feature = Feature.find(params[:feature_id])
    @task.feature = feature
    # set default values
    @task.name = feature.name
    @task.effort = feature.weight*8
    # @task.start = @task.get_last_start
    @task.start = Date.today
    flash[:sp] = @sprint_id
    logger.debug " new flash #{flash[:sp]}"

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @task }
    end
  end

  # GET /tasks/1/edit
  def edit
    @task = Task.find(params[:id])
    flash[:sp] = @sprint_id
    logger.debug "flash #{flash[:sp]}"

  end

  # POST /tasks
  # POST /tasks.xml
  def create
    @task = Task.new(params[:task])
    @task.pending = @task.effort

    flash[:sp] = @sprint_id
    logger.debug "create: flash #{flash[:sp]}"

    respond_to do |format|
      if @task.save
        @task.new_tracks
        format.html { redirect_to( :action => :index, :sprint_id => @sprint_id) }

        #format.html { redirect_to(@task, :notice => 'Task was successfully created.') }
        format.xml  { render :xml => @task, :status => :created, :location => @task }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tasks/1
  # PUT /tasks/1.xml
  def update
    @task = Task.find(params[:id])
    flash[:sp] = @sprint_id
    logger.debug "flash #{flash[:sp]}"

    respond_to do |format|
      if @task.update_attributes(params[:task])

        #format.html { redirect_to(@task, :notice => 'Task was successfully updated.') }
        format.html { redirect_to(tasks_url) }
        format.xml  { head :ok }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
        format.json { render :json => @task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.xml
  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    flash[:sp] = @sprint_id  # to redirect to index, after

    respond_to do |format|
      format.html { redirect_to(tasks_url) }
      format.xml  { head :ok }
    end
  end

private
  def find_sprint
    @sprint_id = params[:sprint_id]
    if !@sprint_id
      @sprint_id = flash[:sp]
    end

    if @sprint_id
      @sprint = Sprint.find(@sprint_id)
    else
      logger.warn "no viene sprint_id, no podemos redireccionar a index"
    end

    flash[:sp] = @sprint.id
  end



end
