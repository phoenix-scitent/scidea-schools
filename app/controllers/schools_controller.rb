class SchoolsController < ApplicationController

  ssl_exceptions
  authorize_resource
  
  def index
    @selected_school = params[:new_school_id] ? School.where("id = ?", params[:new_school_id]).first : nil
    @schools = School.learner_form_search(params[:zipcode], @selected_school)

    render_success
  end

  def create
    @school = School.new params[:school]

    @school.approved = current_user && current_user.is_admin?

    if @school && @school.save
      render :json => @school.to_client_model_json
    else
      render_error
    end
  end
  
  def update
    @school = School.where("id = ?", params[:id]).first

    if @school && @school.update_attributes(params[:school])
      # @schools = School.learner_form_search(@school.zipcode, @school)
      # @selected_school = @school
      render :json => @school.to_client_model_json
      # render_success
    else
      render_error
    end
  end

  def edit
    @school = School.where("id = ?", params[:id]).first

    render :partial => 'form', :layout => false
  end

  private
  def render_success
    render :json => { 
        :status => :ok, 
        :html => render_to_string(:partial => 'search')
      }.to_json 
  end

  def render_error
    render :status => 400, :json => {
        :status => :error,
        :message => 'Your educational institution could not be saved. Please review the form and verify all required fields are completed',
        :html => render_to_string(:partial => 'form.html')
      }.to_json
  end

end
