class GroupUsersController < ApplicationController
  
  # DELETE /group_users/1
  # DELETE /group_users/1.json
  def destroy
    @group_user = GroupUser.find(params[:id])
    @group_user.destroy

    respond_to do |format|
      format.html { redirect_to group_url }
      format.json { head :no_content }
    end
  end
  


end
