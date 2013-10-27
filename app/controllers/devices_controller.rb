require 'net/http'
require 'cgi'

      
class DevicesController < ApplicationController


	def http_get(domain,path,params)
        return Net::HTTP.get(domain, "#{path}?".concat(params.collect { |k,v| "#{k}=#{CGI::escape(v.to_s)}" }.join('&'))) if not params.nil?
        return Net::HTTP.get(domain, path)
  end


	def callback
		device = Device.find(params[:device_id])
		code = params[:code]

		parameters = {:client_id => device.get_client_id, :client_secret => device.get_client_secret, :grant_type => "authorization_code", :redirect_uri => "http://localhost:3000/devices/callback?device_id=#{device.id.to_s}&code=#{code}"}
    logger.debug parameters.to_yaml
    oauth_response = device.get_http_request_for_authentication(parameters)
    json = JSON.parse oauth_response.body
    access_token = json["AccessToken"]
    logger.debug json
    api_user_id = json["UserID"]
    device.access_token = access_token
    device.api_user_id = api_user_id
    device.save
    redirect_to "/patients/#{device.patient_id}"  ##take them to their dashboard
	end

	def create
		##create the device
		patient = Patient.find(params[:patient_id])
		device_type = params[:device_type]
		## do not add a device the patient already has
		device = Device.create(:patient_id => patient.id, :device_type => device_type)


		redirect_to device.get_url_for_device_authorization
	end

	def index
		@patient_id = params[:patient_id]
		@patient_name = Patient.find(@patient_id).name
		@devices = Device.list_of_supported_devices
		@device1 = @devices.first
		@device2 = @devices.last
	end
end
