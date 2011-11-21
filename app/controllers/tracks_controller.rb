class TracksController < ApplicationController

  before_filter :find_sprint

    # GET /track/1/edit
  def edit
    @track = Track.find(params[:id])
    flash[:sp] = @sprint_id

  end

  # PUT /tracks/1
  # PUT /tracks/1.xml
  def update
    @track = Track.find(params[:id])
    flash[:sp] = @sprint_id

    respond_to do |format|
      if @track.update_attributes(params[:track])
        # hay que actualizar desde el actual hasta el final del sprint
        logger.debug "vamos a por todos los pendings de esta task en este sprint"
        @track.update_pendings

        #format.html { redirect_to(@task, :notice => 'Task was successfully updated.') }
        format.html { redirect_to(tasks_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @track.errors, :status => :unprocessable_entity }
        format.json { render :json => @track.errors, :status => :unprocessable_entity }
      end
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

  end
end
