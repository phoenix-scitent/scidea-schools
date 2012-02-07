module Admin
  class SchoolsController < ApplicationController

    ssl_exceptions

    before_filter :authenticate_user!
    authorize_resource

    include ::ActionView::Helpers::TextHelper
    
    has_widgets do |root|
      root << widget(:paginated_list) << widget(:datatable)
    end

    # GET /schools
    def index
      @schools = School.search(params[:search]).
                        order(sort_column + ' ' + sort_direction).
                        paginate(:per_page => per_page, :page => params[:page])
    end

    # GET /schools/1
    def show
      @school = School.where("id = ?", params[:id]).first
    end

    # GET /schools/new
    def new
      @school = School.new :approved => true
    end

    # GET /schools/1/edit
    def edit
      @school = School.where("id = ?", params[:id]).first
    end

    # POST /schools
    def create
      @school = School.new(params[:school])
      
      check_school_approved(@school, params)

      if @school.save
        redirect_to(admin_school_path(@school), :flash => { :success => "Educational institution was successfully created." })
      else
        render :action => "new"
      end
    end

    # PUT /schools/1
    def update
      @school = School.where("id = ?", params[:id]).first

      check_school_approved(@school, params)

      if @school.update_attributes(params[:school])
        redirect_to(admin_school_path(@school), :flash => { :success => "Educational institution was successfully updated." })
      else
        render :action => "edit"
      end
    end

    # DELETE /schools/1
    def destroy
      @school = School.where("id = ?", params[:id]).first
      @school.destroy

      redirect_to(admin_schools_path, :flash => { :success => "Educational institution was successfully deleted." }) 
    end

    # GET /schools/1/migration/new
    def new_migration
      @school = School.where("id = ?", params[:id]).first

      @target_schools = School.search(params[:search]).
                               without_school(@school).
                               order(sort_column + ' ' + sort_direction).
                               paginate(:per_page => per_page, :page => params[:page])
    end

    # GET /schools/1/migration/2/confirm
    def confirm_migration
      @school = School.where("id = ?", params[:id]).first
      @target_school = School.where("id = ?", params[:target_school_id]).first
    end

    # POST /schools/1/migration/2
    def create_migration
      @school = School.where("id = ?", params[:id]).first
      @target_school = School.where("id = ?", params[:target_school_id]).first

      migrated_users = @school.migrate_users_to(@target_school) if @school && @target_school

      if @school && @target_school && migrated_users.size >= 0
        redirect_to(admin_schools_path, :flash => { :success => "Successfully migrated #{pluralize(migrated_users.size, 'user')} " +
                                                               "from #{@school.name} to #{@target_school.name}." }) 
      else
        flash[:error] = "Unable to migrate users between educational institution"
        @target_schools = School.search(params[:search]).
                                 without_school(@school).
                                 order(sort_column + ' ' + sort_direction).
                                 paginate(:per_page => per_page, :page => params[:page])
        render :new_migration
      end
    end
    
    private

    def check_school_approved(school, params)
      if params[:school] && params[:school][:approved]
        school.approved = params[:school][:approved] == '1' 
      end
    end


    def per_page 
      %w[25 50 100].include?(params[:per_page]) ? params[:per_page] : "25"  
    end

    def sort_column  
      %w[name city state zipcode approved].include?(params[:sort]) ? params[:sort] : "name"  
    end

  end
end