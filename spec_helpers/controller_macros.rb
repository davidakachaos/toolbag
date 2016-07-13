# frozen_string_literal: true
module ControllerMacros
  def login_admin
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      user = FactoryGirl.create(:user, :admin)
      user.confirm
      sign_in user
    end
  end

  def login_penthion
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      user = FactoryGirl.create(:user, :penthion)
      user.confirm
      sign_in user
    end
  end

  def login_user(user = nil)
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      user ||= FactoryGirl.create(:user, :open)
      user.confirm # Only necessary if you are using the "confirmable" module
      sign_in user
    end
  end
end
