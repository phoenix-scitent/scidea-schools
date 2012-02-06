require "spec_helper"

describe SchoolsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "schools" }.should route_to(:controller => "schools", :action => "index" )
    end

    it "should not recognize #new" do
      { :get => "schools/new" }.should_not be_routable
    end

    it "should not recognize #show" do
      { :get => "schools/1" }.should_not be_routable
    end

    it "should recognize #edit" do
      { :get => "schools/1/edit" }.should route_to(:controller => "schools", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "schools" }.should route_to(:controller => "schools", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "schools/1" }.should route_to(:controller => "schools", :action => "update", :id => "1")
    end

    it "should not recognize #destroy" do
      { :delete => "schools/1" }.should_not be_routable
    end

  end
end
