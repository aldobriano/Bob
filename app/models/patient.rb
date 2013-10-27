class Patient < ActiveRecord::Base
  attr_accessible :name, :phone, :mobile, :email, :age, :gender

  has_many :users
  
  def gender_label
  	return gender == "male" ? "his" : "her"
  end

  ## for now its random, but it should grab it from the data
  def get_advice
  	advice = [
  		{:message => "#{self.name.capitalize}'s blood pressure is a little high.  Help #{self.gender_label} relax by sending a funny picture of #{self.gender_label} grandchildren.", :action =>"picture"},
  		{:message => "#{self.name.capitalize}'s number of steps this week was below average.  Encourage #{self.gender_label} to go out of the house by sending #{self.gender_label} a movie ticket.", :action => "gift"},
  		{:message => "Congratulate #{self.name.capitalize} on #{self.gender_label} amazing weight loss.  Send #{self.gender_label} a treat.", :action => "gift"},
  		{:message => "Thinking about #{self.name.capitalize}?  Give #{self.gender_label} a call to tell #{self.gender_label} you are proud of #{self.gender_label}.", :action => "call"},
  		{:message => "Help #{self.name.capitalize} maintain #{self.gender_label} weight by sending a low sodium entree from #{self.gender_label} favorite restaurant.", :action => "food"},
  		{:message => "Have a family event you would love #{self.name.capitalize} to attend?  Send a personal driver to pick #{self.gender_label} up.", :action => "taxi"},
  		{:message => "Busy with your child's first dance showcase? Lighthouse taxi will take care of #{self.name.capitalize} from pickup to drop-off.", :action => "taxi"},
  		{:message => "It's time to pay it forward.  Arrange a date to a cooking class.  Low sodium of course!", :action => "gift"}
  	]

  	return advice[1]

  end


  def self.get_icon_from_action(action)
  	if(action == "picture")
  		return "glyphicon glyphicon-camera"
  	elsif(action == "message")
  		return "glyphicon glyphicon-envelope"
  	elsif(action == "call")
  		return "glyphicon glyphicon-phone-alt"
  	elsif(action == "taxi")
  		return "glyphicon glyphicon-road"
  	elsif(action == "gift")
  		return "glyphicon glyphicon-gift"
  	elsif(action == "food")
  		return "glyphicon glyphicon-cutlery"
  	end
  end
end
