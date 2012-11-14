class RegistrationsController < Devise::RegistrationsController
  def create
    unless params[:user][:role].present? && current_user.role?(:superadmin)
      params[:user][:role] = "editor"
    end
    super
  end
end
