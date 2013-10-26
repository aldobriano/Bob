class Patient < ActiveRecord::Base
  attr_accessible :name, :phone, :mobile, :email, :age, :gender

  has_many :users
end
