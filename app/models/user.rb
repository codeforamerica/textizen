class User < ActiveRecord::Base
  # Include default devise modules. Others available are: :registerable
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  if Rails.env.production?
    devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable
  else
    devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :registerable 
  end

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
  has_many :polls, :through => :groups
  has_many :created_polls, :class_name => "Poll", :foreign_key => "user_id"
  has_and_belongs_to_many :groups

end
