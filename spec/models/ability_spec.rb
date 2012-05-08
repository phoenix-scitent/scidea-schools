require 'spec_helper'

describe Ability do
  describe "as a course admin user" do
    subject { Ability.new(FactoryGirl.build(:user_course_admin), 'Admin') }
    
    it { should be_able_to(:manage, School) }
  end

  describe "as a learner user" do
    subject { Ability.new(FactoryGirl.build(:user_learner)) }

    it { should be_able_to(:create, School) }
    it { should be_able_to(:update, School) }
    it { should be_able_to(:index, School) }
  end

  describe "as an unregistered user" do
    subject { Ability.new(User.new) }
    
    it { should be_able_to(:create, School) }
    it { should be_able_to(:update, School) }
    it { should be_able_to(:index, School) }   
    it { should be_able_to(:create, User) }
  end

end
