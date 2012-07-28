class Ability
  include CanCan::Ability

  def initialize(user)
    if user.role?(:superadmin)
      can :manage, :all
      can :access, :rails_admin   # grant access to rails_admin
      can :dashboard              # grant access to the dashboard
      #can :view_all, Poll # TODO
    elsif user.role?(:editor)
      can :create, Poll # editor can create polls
      can :manage, Poll, :groups => { :id => user.group_ids } # editor can manage polls in their groups
      can :manage, Poll, :author => { :id => user.id } # and also polls they created
      can :create, Group
      can :manage, Group, :users => { :id => user.id } # can manage groups they're members of
      can :manage, GroupUser, :groups => { :id => user.group_ids } # allows anyone to remove themselves from a group, or add polls to a group they're in
    end
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
