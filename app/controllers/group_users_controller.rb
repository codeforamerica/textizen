class GroupUsersController < ApplicationController

  # DELETE /group_users/1
  # DELETE /group_users/1.json
  def destroy
    @group_user = GroupUser.find(params[:id])
    @group_user.destroy

    respond_to do |format|
      format.html { redirect_to edit_group_path(@group_user.group) }
      format.json { head :no_content }
    end
  end

end
