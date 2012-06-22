class User < ActiveRecord::Base
  # Include default devise modules. Others available are: :registerable
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  if Rails.env.production?
    devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable
  else
    devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :registerable 
  end

  ROLES = %w[editor superadmin]
  # for role inheritance
  def role?(base_role)
    ROLES.index(base_role.to_s) <= ROLES.index(role)
  end

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :role
  # attr_accessible :title, :body
  has_many :polls, :through => :groups
  has_many :created_polls, :class_name => "Poll", :foreign_key => "user_id"
  has_many :groups_users
  has_many :groups, :through => :groups_users

  validates :role, :inclusion => { :in => ROLES, :message => "%{value} is not a valid user role" }


end
