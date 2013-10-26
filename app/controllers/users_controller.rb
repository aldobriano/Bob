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
	  session[:user_id] = @user.id
	  if(params[:patient_id].present?)
	  	@user.patient_id = params[:patient_id]
	  	@user.save!
	  	#redirect to the dashboard for that patient
		  redirect_to "/"
		else
			redirect_to "/patients/new"
		end
	end

	def invite
		@patient = Patient.find(params[:patient_id])
	end

	def send_invitation
		@patient = Patient.find(params[:patient_id])
	
		if(params[:name1].present? && params[:email1].present?)
			User.invite(params[:name1],params[:email1],@patient)
		end
		if(params[:name2].present? && params[:email2].present?)
			User.invite(params[:name2],params[:email2],@patient)
		end
		if(params[:name3].present? && params[:email3].present?)
			User.invite(params[:name3],params[:email3],@patient)
		end
		if(params[:name4].present? && params[:email4].present?)
			User.invite(params[:name4],params[:email4],@patient)
		end

		redirect_to "/"   ##dashboard
	end

	def signup

		if(params[:id].present? && Patient.exists?(:id => params[:id]))
			@patient = Patient.find(params[:id])
		end
	end

	def login

	end
	def do_login
		email = params[:email]
    password = params[:password]
    user = User.find_by_email(email)
    return redirect_to "/users/signup", :notice => "There is no user with email address #{email} signed up.  Please sign up."  if !user.present?
		
    if(!user.authenticate(password))
    	logger.debug "invalid password"
    	return redirect_to "/login", :notice => "Invalid password"
		
    else
    	logger.debug "valid password"
    	session[:user_id] = user.id
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