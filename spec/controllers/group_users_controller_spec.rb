require 'spec_helper'

describe GroupUsersController do
  login_user

  before :each do
    @group_user = FactoryGirl.create(:group_user) 
  end

  describe "DELETE destroy" do
    it "destroys the requested group_user" do
      expect {
        delete :destroy, {:id => @group_user.id}
      }.to change(GroupUser, :count).by(-1)

    end

    it "redirects to the edit group page" do
      delete :destroy, {:id => @group_user.id}
      response.should redirect_to(edit_group_path(@group_user.group))
    end
  end
end
