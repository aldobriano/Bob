class PatientsController < ApplicationController
  #

  # GET /patients/1
  # GET /patients/1.json
  def show
    @patient = Patient.find(params[:id])
    @advice = @patient.get_advice
    @devices = Device.where(:patient_id => @patient.id)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @patient }
    end
  end

  # GET /patients/new
  # GET /patients/new.json
  def new

    @patient = Patient.new
   
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @patient }
    end
  end

  

  # POST /patients
  # POST /patients.json
  def create
    
    @patient = Patient.new(:name => params[:name], :age => params[:age], :email => params[:email], :phone => params[:phone], :mobile => params[:mobile], :gender => params[:gender])


    respond_to do |format|
      if @patient.save
        caregiver = User.find_by_id(params[:caregiver_id]) || current_user
        caregiver.patient_id = @patient.id
        caregiver.save!

        #### invite more caregivers screen ###


        format.html { redirect_to "/users/invite?patient_id=" + @patient.id.to_s, notice: 'Patient was successfully created.' }
        format.json { render json: @patient, status: :created, location: @patient }
      else
        format.html { render action: "new" }
        format.json { render json: @patient.errors, status: :unprocessable_entity }
      end
    end
  end

  
end
