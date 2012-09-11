class InvitationsController < Devise::InvitationsController
  def new
    p "NEW**********"
    super
  end

  def create
    p "CREATE*********"
    p resource_params
    super
  end

  def update
    super
  end
end
