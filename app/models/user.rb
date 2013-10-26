class User < ActiveRecord::Base
  # attr_accessible :title, :body
  has_secure_password
  validates_presence_of :email, :on => :create
  validates_uniqueness_of :email, :on => :create
  validates_presence_of :password, :on => :create

end
