require 'spec_helper'

describe Admin::SchoolsController do
  let(:admin) { Factory.create(:user_user_admin) }
  let(:school) { Factory.create :school }
  
  describe "DELETE :destroy" do
    context "school has a user" do
      login_scitent_admin

      before do
        Factory :profile, :school => school
      end

      it "does not delete the school when it is tied to a profile" do
        delete :destroy, :id => school.id
        assigns(:school).should_not be_destroyed
      end
    end
    
    context "school has no user" do
      login_scitent_admin

      it "does delete the school when it is not tied to a profile" do
        delete :destroy, :id => school.id
        assigns(:school).should be_destroyed
      end
    end
  end
end