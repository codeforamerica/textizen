class User < ActiveRecord::Base
  # Include default devise modules. Others available are: :registerable
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  # only allow signups on dev machines during the beta. TODO make this a config var, not hardcoded?

  if ENV['BLOCK_REGISTRATIONS'] == 'true'
    devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable
  else
    devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :registerable 
  end

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :role
  # attr_accessible :title, :body
  has_many :created_polls, :class_name => "Poll", :foreign_key => "user_id"
  has_many :group_users
  has_many :groups, :through => :group_users
  has_many :polls, :through => :groups

  ROLES = %w[editor superadmin]
  validates :role, :inclusion => { :in => ROLES, :message => "%{value} is not a valid user role" }


  # for role inheritance
  def role?(base_role)
    unless role.nil?
      ROLES.index(base_role.to_s) <= ROLES.index(role)
    else
      false #if no role defined, default to always failing
    end
  end

  def visible_polls
    if role?(:superadmin)
      return Poll.all
    else
      return polls | created_polls #union of poll and created_polls for non admin users
    end
  end



end
