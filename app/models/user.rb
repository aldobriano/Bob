class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :phone, :relationship, :remote
  
  has_secure_password
  validates_presence_of :email, :on => :create
  validates_uniqueness_of :email, :on => :create
  validates_presence_of :password, :on => :create

end
