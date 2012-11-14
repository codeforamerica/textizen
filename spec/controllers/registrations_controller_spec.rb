require 'spec_helper'

describe RegistrationsController do

  describe "POST create" do
    context "user role is set in params" do
      login_admin_user

      it "respects the passed in user role" do
        attrs = { :user => FactoryGirl.attributes_for(:user, :role => "superadmin") }

        post :create, attrs

        User.count.should == 2
        User.last.role.should == "superadmin"
      end
    end

    context "no user role param passed in" do
      login_user

      it "sets the user's role to editor" do
        attrs = { :user => FactoryGirl.attributes_for(:user) }

        post :create, attrs
        
        User.count.should == 2
        User.last.role.should == "editor"
      end
    end
  end
end
