class ProjectsController < ApplicationController
    before_action :set_project, only: [:show, :edit, :update, :destroy, :users, :add_user]
   
  
    # GET /projects
    # GET /projects.json
    def index
    end
  
    # GET /projects/1
    # GET /projects/1.json
    def show
    end
  
    # GET /projects/new
    def new
      @project = Project.new
    end
  
    # GET /projects/1/edit
    def edit
    end
  
    # POST /projects
    # POST /projects.json
    def create
      @project = Project.new(project_params)
      @project.users << current_user
      respond_to do |format|
        if @project.save
          format.html { redirect_to root_url, notice: 'Project was successfully created.' }
        else
          format.html { render :new }
        end
      end
    end
  
    # PATCH/PUT /projects/1
    # PATCH/PUT /projects/1.json
    def update
      respond_to do |format|
        if @project.update(project_params)
          format.html { redirect_to root_url, notice: 'Project was successfully updated.' }
        else
          format.html { render :edit }
        end
      end
    end
  
    # DELETE /projects/1
    # DELETE /projects/1.json
    def destroy
      @project.destroy
      respond_to do |format|
        format.html { redirect_to root_url, notice: 'Project was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
    
    def users

    end
    
    def add_user
      @project_user = UserProject.new(user_id: params[:user_id], project_id: @project.id)
      
  
    end
  
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_project
        @project = Project.find(params[:id])
      end
  
      # Never trust parameters from the scary internet, only allow the white list through.
      def project_params
        params.require(:project).permit(:title, :details, :expected_completion_date)
      end
    
  end