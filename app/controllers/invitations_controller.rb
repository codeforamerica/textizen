class InvitationsController < Devise::InvitationsController 
  def resend
    User.find(params[:id]).invite! if params[:id]
    
    respond_to do |format|
      format.json { head :no_content }
    end

  end
end
