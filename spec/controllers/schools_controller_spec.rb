require 'spec_helper'

describe SchoolsController do
  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:user_user_admin) }
  let(:school) { mock_model(School).as_null_object }


  describe "create" do
    context "logged in as admin" do
      login_scitent_admin

      before do
        School.stub(:new).and_return(school)
      end

      it "assigns a school" do
        post :create, :id => "123"
        assigns[:school].should eq(school)
      end

      it "calls approved=true" do
        school.should_receive(:approved=).with(true)
        post :create, :id => "123"
      end
    end

    context "not logged in" do
      before do
        School.stub(:new).and_return(school)
      end

      it "assigns a school" do
        post :create, :id => "123"
        assigns[:school].should eq(school)
      end

      it "calls approved=false" do
        school.should_receive(:approved=).with(nil)
        post :create, :id => "123"
      end
    end
  end
end