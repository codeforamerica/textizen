class RegistrationsController < Devise::RegistrationsController 
  def create
    if params[:user][:role].present? && current_user.role?(:superadmin)
      # all is well
    else
      params[:user][:role] = "editor"
    end
    super
  end
end
