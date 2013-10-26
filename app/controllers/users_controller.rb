class UsersController < ApplicationController
	def create
	  email = params[:email]
	  password = params[:password]
	  name = params[:name]
	  phone = params[:phone]
	  remote = params[:remote]

	  if(!email.present? || !password.present? || !name.present? || !phone.present?)
	  	redirect_to "/users/signup", :notice => "Missing fields. All Fields are necessary."
	
	  end
	  if(User.exists?(:email => email))
	  	redirect_to "/users/login", :notice => "There is already an account with that email, please log in."
	  end
	  @user = User.create(:name => name, :email => email, :password => password, :phone => phone)
		session[:current_user] = user.id
		redirect_to "/"
	end


	def signup

	end

	def login
		email = params[:email]
    password = params[:password]
    user = User.find_by_email(email)
    return redirect_to "/users/signup", :notice => "There is no user with email address #{email} signed up.  Please sign up."  if !user.present?
		
    if(!user.authenticate(password))
    	logger.debug "invalid password"
    else
    	logger.debug "valid password"
    end
    redirect_to "/"
	end
end



# ser = User.find_by_email(params[:email])
# 	  if user && user.authenticate(params[:password])
# 	    session[:user_id] = user.id
# 	    redirect_to admin_root_path, :notice => "Welcome back, #{user.email}"
# 	  else
# 	    flash.now.alert = "Invalid email or password"
# 	    render "new"
# 	  end