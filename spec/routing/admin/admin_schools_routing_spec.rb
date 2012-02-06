require "spec_helper"

describe Admin::SchoolsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/admin/schools" }.should route_to(:controller => "admin/schools", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/admin/schools/new" }.should route_to(:controller => "admin/schools", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/admin/schools/1" }.should route_to(:controller => "admin/schools", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/admin/schools/1/edit" }.should route_to(:controller => "admin/schools", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/admin/schools" }.should route_to(:controller => "admin/schools", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/admin/schools/1" }.should route_to(:controller => "admin/schools", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/admin/schools/1" }.should route_to(:controller => "admin/schools", :action => "destroy", :id => "1")
    end

    it "recognizes and generates #new_migration" do
      { :get => "/admin/schools/1/migration/new" }.should route_to(:controller => "admin/schools", :action => "new_migration", :id => "1")
    end

    it "recognizes and generates #confirm_migration" do
      { :get => "/admin/schools/1/migration/2/confirm" }.should route_to(:controller => "admin/schools", :action => "confirm_migration", :id => "1", :target_school_id => "2")
    end

    it "recognizes and generates #migration" do
      { :post => "/admin/schools/1/migration/2" }.should route_to(:controller => "admin/schools", :action => "create_migration", :id => "1", :target_school_id => "2")
    end

  end
end
