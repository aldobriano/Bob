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
    redirect_to "/"  ##take them to their dashboard
	end

	def create
		##create the device
		## send to oauth

	end
end
