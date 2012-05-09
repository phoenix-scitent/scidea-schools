module ControllerMacros
  def login_scitent_admin
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:users]
      sign_in FactoryGirl.create(:user_scitent_admin)
    end
  end

  def login_learner
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:users]
      sign_in FactoryGirl.create(:user_learner)
    end
  end
end