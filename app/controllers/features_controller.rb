class FeaturesController < ApplicationController

  helper_method :sort_column, :sort_direction

  # GET /features
  # GET /features.xml
  def index
    @features = Feature.all(:include => [:sprint, :project], :order => sort_column + " " + sort_direction)
    #@feature = Feature.first()

    calculate_stadistics


    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @features }
    end
  end

  # GET /features/1
  # GET /features/1.xml
  def show
    @feature = Feature.find(params[:id], :include => :sprint)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @feature }
      format.json { render :json => @feature.as_json }
    end
  end

  # GET /features/new
  # GET /features/new.xml
  def new
    @feature = Feature.new
    @feature.start = Date.today

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @feature }
    end
  end

  # GET /features/1/edit
  def edit
    @feature = Feature.find(params[:id], :include => :sprint)
  end

  # POST /features
  # POST /features.xml
  def create
    @feature = Feature.new(params[:feature])

    respond_to do |format|

      if @feature.save
        #format.html { redirect_to(@feature, :notice => 'Feature was successfully created.') }
        format.html { redirect_to(features_url, :notice => 'Feature was successfully created.') }
        format.xml  { render :xml => @feature, :status => :created, :location => @feature }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @feature.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /features/1
  # PUT /features/1.xml
  def update
    @feature = Feature.find(params[:id])

    respond_to do |format|
      logger.debug "feature = #{@feature.name}, sprint #{@feature.sprint_id}, "

      if @feature.update_attributes(params[:feature])
        @feature.update_tasks
        format.html { redirect_to(features_url) }
        format.xml  { head :ok }
        format.json { head :ok }
        #format.html { redirect_to(@feature, :notice => 'Feature was successfully updated.') }
        #format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @feature.errors, :status => :unprocessable_entity }
        format.json { render :json => @feature.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /features/1
  # DELETE /features/1.xml
  def destroy
    @feature = Feature.find(params[:id])
    @feature.destroy

    respond_to do |format|
      format.html { redirect_to(features_url) }
      format.xml  { head :ok }
    end
  end

  private

  def sort_column
    (Feature.column_names + %w[sprints.name projects.name]).include?(params[:sort]) ? params[:sort] : "id"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def calculate_stadistics
    my_features = Feature.all(:include => :sprint, :order => "sprints.start")
    sprints_number = Sprint.all.count
    @total_weight = Array.new(sprints_number, 0)
    @activity_weight = Array.new(sprints_number, 0)
    @support_weight = Array.new(sprints_number, 0)
    @bug_weight = Array.new(sprints_number, 0)
    @planned_weight = Array.new(sprints_number, 0)
    @unplanned_weight = Array.new(sprints_number, 0)

    old = -1
    i = -1

    if !my_features.first.nil?

      my_features.each do |fea|

        if !fea.sprint.nil?
          if old != fea.sprint_id
            old = fea.sprint_id
            i += 1
          end
          @total_weight[i] += fea.weight

          case fea.kind
            when Feature::ACTIVITY
              @activity_weight[i] += fea.weight
            when Feature::BUG
              @bug_weight[i] += fea.weight
            when Feature::SUPPORT
              @support_weight[i] += fea.weight
          end

          if fea.start > fea.sprint.start
            @unplanned_weight[i] += fea.weight
          else
            @planned_weight[i] += fea.weight
          end
        end

      end
    end
  end


end
