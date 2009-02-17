class SprintsController < ApplicationController
  include ProjectDependent

  # GET /project/1/sprints
  # GET /project/1/sprints.xml
  def index
    @sprints = @project.sprints.find(:all, :order => "start_date desc" )

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sprints }
    end
  end

  # GET /project/1/sprints/1
  # GET /project/1/sprints/1.xml
  def show
    @sprint = @project.sprints.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @sprint }
    end
  end

  # GET /project/1/sprints/new
  # GET /project/1/sprints/new.xml
  def new
    if @project.sprints.count == 0
      @sprint = Sprint.create_new(@project)
    elsif @project.sprints.last.end_date < Date.today
      @sprint = Sprint.create_next(@project.sprints.last)
    else
      flash[:notice] = "Existe ainda um sprint em andamento"
      redirect_to project_sprints_url(@project)
      return
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @sprint }
    end
  end

  # GET /project/1/sprints/1/edit
  def edit
    @sprint = @project.sprints.find(params[:id])
  end

  def list_stories
    @sprint = Sprint.find(params[:id])
    @all_stories = Story.find(:all, :conditions => ["project_id = ?", @project.id])

    respond_to do |format|
      format.html { render :action => "list_stories" }
      format.xml  { render :xml => @sprint.stories }
    end
  end

  # POST /project/1/sprints
  # POST /project/1/sprints.xml
  def create
    @sprint = @project.sprints.build(params[:sprint])

    respond_to do |format|
      if @sprint.save
        flash[:notice] = 'Sprint was successfully created.'
        format.html { redirect_to project_sprints_path(@project) }
        format.xml  { render :xml => @sprint, :status => :created, :location => @sprint }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @sprint.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /project/1/sprints/1
  # PUT /project/1/sprints/1.xml
  def update
    @sprint = @project.sprints.find(params[:id])

    respond_to do |format|
      if @sprint.update_attributes(params[:sprint])
        flash[:notice] = 'Sprint was successfully updated.'
        format.html { redirect_to( project_sprints_path(@project)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @sprint.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /project/1/sprints/1
  # DELETE /project/1/sprints/1.xml
  def destroy
    @sprint = @project.sprints.find(params[:id])
    @sprint.destroy

    respond_to do |format|
      format.html { redirect_to(project_sprints_url(@project)) }
      format.xml  { head :ok }
    end
  end

  def save_stories
    @sprint = Sprint.find(params[:id])
    @sprint.stories = Story.find(params[:story_ids]) if params[:story_ids]

    respond_to do |format|
      if @sprint.save
        flash[:notice] = 'Sprint was successfully created.'
        format.html { redirect_to(@sprint) }
        format.xml  { render :xml => @sprint, :status => :created, :location => @sprint }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @sprint.errors, :status => :unprocessable_entity }
      end
    end
  end
end
