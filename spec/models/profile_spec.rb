require 'spec_helper'

describe Profile do
  subject { Factory(:profile) }

  it { should belong_to(:school) }

  describe "school validation" do
    context "there exists a few audiences, including educator" do
      before do
        @doctor_audience  = Factory :audience, :name => "Doctor"
        @educator_audience = Factory :audience, :name => "Educator"
      end

      context "A profile is created with a non-educators audience and without a school;" do
        it "should be a valid profile" do
          @profile = Factory :profile, :audience => @doctor_audience
          @profile.valid?.should be_true
        end
      end

      context "A profile is created with a educators audience;" do
        context "the profile does not have a school associated with it;" do
          it "should not be a valid profile" do
            lambda{ Factory :profile, :audience => @educator_audience, :school => nil }.should raise_error
          end
        end
  
        context "the profile does have a school associated with it;" do
          it "should be a valid profile" do
            @profile = Factory :profile, :audience => @educator_audience, :school => Factory(:school)
            @profile.valid?.should be_true
          end
        end
      end
    end 
  end #describe 
end
