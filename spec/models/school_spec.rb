require 'spec_helper'

describe School do

  subject { FactoryGirl.create(:school) }

  it { should validate_presence_of(:address_1) }
  it { should validate_presence_of(:city) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:state) }
  it { should validate_presence_of(:zipcode) }

  it { should have_many(:profiles) }

  describe "zipcode formatting" do
    it "should only persist the first five digits" do
      lambda{ FactoryGirl.create(:school, :zipcode => '123456') }.should raise_error
    end

    it "should only accept numerical values" do
      lambda{ FactoryGirl.create(:school, :zipcode => 'a2345') }.should raise_error
    end

    it "should require full five digits" do
      lambda{ FactoryGirl.create(:school, :zipcode => '1234') }.should raise_error
    end
  end

  describe "search" do
    context "there are no schools" do
      it "it should return no results" do
        School.search('whatever').should be_empty
      end
    end

    context "there exist two schools with different names but the same zipcodes" do
      before do
        @shared_zipcode = '12345'
        @temple = FactoryGirl.create :school, :name => 'Temple University', :zipcode => @shared_zipcode
        @drexel = FactoryGirl.create :school, :name => 'Drexel University', :zipcode => @shared_zipcode
        @unc    = FactoryGirl.create :school, :name => 'University of North Carolina', :zipcode => '00000'
      end

      it "should return no schools if no search terms match" do
        School.search('whatever').should be_empty
      end

      it "should only return schools that contain the search term in their name" do
        (School.search(@temple.name) - [@temple]).should be_empty
      end

      it "should return all schools that match the search terms by zipcode" do
        (School.search(@shared_zipcode) - [@temple, @drexel]).should be_empty
      end

    end
  end

  describe "user_count" do
    context "there are two schools, each with different amounts of users" do
      before do
        @school_a = FactoryGirl.create :school
        @school_b = FactoryGirl.create :school
        @school_a_users = 1
        @school_b_users = 3
        @school_a_users.times { FactoryGirl.create :profile, :school => @school_a }
        @school_b_users.times { FactoryGirl.create :profile, :school => @school_b }
      end

      it "should return the number of profiles associated with the school" do
        @school_a.user_count.should == @school_a_users
        @school_b.user_count.should == @school_b_users
      end
    end
  end

  describe "migrate_users_to" do
    before do
      @school = FactoryGirl.create :school
    end

    it "should throw an error if target school is nil" do
      lambda { @school.migrate_users_to(nil) }.should raise_error
    end

    context "there is a valid target school" do
      before do
        @target_school = FactoryGirl.create :school
      end

      it "should migrate and return 0 users" do
        @school.migrate_users_to(@target_school).should be_empty
      end

      context "there are multiple useres in a school" do
        before do
          2.times { FactoryGirl.create :profile, :school => @school }
          @users = @school.profiles.map{ |p| p.user }
        end

        it "should return all users that were in the school" do
          (@school.migrate_users_to(@target_school) - @users).should be_empty
        end

        it "should remove all users from that school" do
          @school.migrate_users_to(@target_school)
          @school.user_count.should == 0
        end

        it "should add all users to the target school" do
          migrated_users = @school.migrate_users_to(@target_school)
          (@users - migrated_users).should be_empty
        end
      end
    end

  end # describe migrate_users_to

  describe "learner_form_search" do
    before do
      @zipcode = '99999'
    end

    context "when searching by a bad zipcode" do
      it "will return an empty result set" do
        School.learner_form_search('abcde').should be_empty
      end
    end

    context "there are no schools" do
      it "will return an empty result set" do
        School.learner_form_search(@zipcode).should be_empty
      end

      context "and a user-created school is passed as a paramter" do
        before do
          @user_created_school = FactoryGirl.create :school, :approved => false, :zipcode => '31415'
        end

        it "will return only the user created school" do
          School.learner_form_search(@user_created_school.zipcode, @user_created_school).should == [@user_created_school]
        end

        context "and the user-created school is from a zipcode different from the search parameter" do
          it "should return an empty result set" do
            School.learner_form_search(@zipcode, @user_created_school).should be_empty
          end
        end
      end
    end

    context "there are several schools in different zipcodes" do
      before do
        @c_school = FactoryGirl.create :school, :name => 'C School', :zipcode => @zipcode
        @b_school = FactoryGirl.create :school, :name => 'B School'
        @a_school = FactoryGirl.create :school, :name => 'A School', :zipcode => @zipcode
      end

      context "when searching by a zipcode with two schools in it;" do
        it "should return the two schools, sorted ascending by name" do
          School.learner_form_search(@zipcode).should == [@a_school, @c_school]
        end

        context "and a user-created school (with the same zipcode) is passed as a paramter" do
          before { @user_created_school = FactoryGirl.create :school, :name => 'Ac School', :approved => false, :zipcode => @zipcode }

          it "will return the two existing schools and the user-created school" do
            School.learner_form_search(@zipcode, @user_created_school).should == [@a_school, @user_created_school, @c_school]
          end

          context "and the user-created school is from a zipcode different from the search parameter" do
            before do
              @user_created_school.zipcode = '31415'
              @user_created_school.save
            end

            it "should the original result set without the user created school" do
              School.learner_form_search(@zipcode, @user_created_school).should == [@a_school, @c_school]
            end

            context "the user-created school is nil" do
              before { @user_created_school = nil }

              it "should the original result set without the user created school" do
                School.learner_form_search(@zipcode, @user_created_school).should == [@a_school, @c_school]
              end            
            end
          end
        end # user-created school passed as a parameter
      end

      context "when searching by a zipcode with two schools, one pending admin approval" do
        before do
          @c_school.approved = false
          @c_school.save
          @results = School.learner_form_search(@zipcode)
        end

        it "should only return the school that is approved" do
          @results.should == [@a_school]
        end
      end

      context "when searching by a bad zipcode" do
        it "will return an empty result set" do
          School.learner_form_search('abcde').should be_empty
        end
      end

    end # several schools
 
  end # describe learner_form_search

  describe "render_form?" do
    context "when there do not exist any schools" do
      before { School.stub(:count).and_return(0) }

      it "will return false" do
        School.render_form?.should be_false
      end
    end

    context "when there exists a school" do
      before do 
        School.stub(:count).and_return(1)
        Audience.stub(:count).and_return(0)
      end

      it "will return false" do
        School.render_form?.should be_false
      end

      context "and an audience" do
        before { Audience.stub(:count).and_return(1) }

        it "will return true" do
          School.render_form?.should be_true
        end
      end
    end
  end # describe render_form?

  describe "to_client_model_json" do
    context "the record is new" do
      it "should not contain created_at" do
        School.new.to_client_model_json.include?('created_at').should be_false
      end

      it "should not contain updated_at" do
        School.new.to_client_model_json.include?('updated_at').should be_false
      end
    end

    context "the record has been persisted" do
      it "should not contain created_at" do
        subject.to_client_model_json.include?('created_at').should be_false
      end

      it "should not contain updated_at" do
        subject.to_client_model_json.include?('updated_at').should be_false
      end
    end
  end

  describe "phone validation" do
    before { @school = FactoryGirl.create :school }

    context "the phone number is valid;" do
      context "it contains extra characters" do
        before { @school.phone = '987-654-2310' }

        it "should return a value without extra characters" do
          @school.phone.should == '(987) 654-2310'
        end
      end
    end

    context "the phone number is missing" do
      before { @school.phone = '' }

      it "should not validate" do
        @school.valid?.should be_false
      end
    end

    context "the phone number contains only non-numeric values" do
      before { @school.phone = 'abcdefg' }

      it "should not validate" do
        @school.valid?.should be_false
      end
    end

    context "the phone number is invalid (too short);" do     
      before { @school.phone = '123' }

      it "should not validate" do

        @school.valid?.should be_false
      end
    end
  end

end
