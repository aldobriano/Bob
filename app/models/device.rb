require 'net/http'
class Device < ActiveRecord::Base
  attr_accessible :patient_id, :device_type, :api_user_id

  def get_url_for_device_authorization
  	parameters = {:client_id => self.get_client_id}
  	
  	if(self.device_type == "OpenApiBP")
  		url = "https://api.ihealthlabs.com:8443/OpenApiV2/OAuthv2/userauthorization/" + "?".concat(parameters.collect { |k,v| "#{k}=#{v.to_s}" }.join('&')) + "&APIName=OpenApiBP&response_type=code&redirect_uri=http://localhost:3000/devices/callback?device_id=#{self.id.to_s}"

  	elsif(self.device_type == "OpenApiWeight")
  		url = "https://api.ihealthlabs.com:8443/OpenApiV2/OAuthv2/userauthorization/" + "?".concat(parameters.collect { |k,v| "#{k}=#{v.to_s}" }.join('&')) + "&APIName=OpenApiWeight&response_type=code&redirect_uri=http://localhost:3000/devices/callback?device_id=#{self.id.to_s}"

  	end
  end

  def get_http_request_for_authentication(parameters)
  	if(self.device_type == "OpenApiBP")
  		
  		uri = URI.parse("https://api.ihealthlabs.com:8443/OpenApiV2/OAuthv2/userauthorization/" + "?".concat(parameters.collect { |k,v| "#{k}=#{v.to_s}" }.join('&')))   
  		logger.debug uri.to_s
  		http = Net::HTTP.new(uri.host, uri.port)
  		http.use_ssl = true

  		
  		return http.request(Net::HTTP::Get.new(uri.request_uri))

  	elsif(self.device_type == "OpenApiWeight")
  		uri = URI.parse("https://api.ihealthlabs.com:8443/OpenApiV2/OAuthv2/userauthorization/" + "?".concat(parameters.collect { |k,v| "#{k}=#{v.to_s}" }.join('&')))   
  		logger.debug uri.to_s
  		http = Net::HTTP.new(uri.host, uri.port)
  		http.use_ssl = true

  		
  		return http.request(Net::HTTP::Get.new(uri.request_uri))

  	end	
  end

  def get_data_from_device
  	parameters = {:client_id => self.get_client_id, :client_secret => self.get_client_secret, :access_token => self.access_token}
  	if(self.device_type == "OpenApiBP")
  		begin
	  		uri = URI.parse("https://api.ihealthlabs.com:8443/openapiv2/user/" + self.api_user_id + "/bp.json?".concat(parameters.collect { |k,v| "#{k}=#{v.to_s}" }.join('&')))   
	  		
	  		http = Net::HTTP.new(uri.host, uri.port)
	  		http.use_ssl = true

	  		
	  		response = http.request(Net::HTTP::Get.new(uri.request_uri))
	  		json = JSON.parse response.body
	  		s_bp = json["BPDataList"][0]["HP"]
	  		d_bp = json["BPDataList"][0]["LP"]
	  	rescue
	  		s_bp = 0
	  		d_bp = 0
	  	end
  		return {:s_bp => s_bp, :d_bp => d_bp}

  	elsif(self.device_type == "OpenApiWeight")
  		begin
	  		uri = URI.parse("https://api.ihealthlabs.com:8443/openapiv2/user/" + self.api_user_id + "/weight.json?".concat(parameters.collect { |k,v| "#{k}=#{v.to_s}" }.join('&')))   
	  		
	  		http = Net::HTTP.new(uri.host, uri.port)
	  		http.use_ssl = true

	  		
	  		response = http.request(Net::HTTP::Get.new(uri.request_uri))
	  		json = JSON.parse response.body

	  		weight_unit = json["WeightUnit"]
	  		last_weight_measure = json["WeightDataList"][0]["WeightValue"]
	  		if(weight_unit.to_i == 0)
	  			last_weight_measure_lbs = last_weight_measure.to_f * 2.2
	  		end
	  		number_of_records = json["CurrentRecordCount"]
	  		to_return = {:weight => last_weight_measure_lbs}


	  		if(number_of_records.to_i > 5)
	  			arr = [json["WeightDataList"][1]["WeightValue"].to_f,json["WeightDataList"][2]["WeightValue"].to_f,json["WeightDataList"][3]["WeightValue"].to_f,json["WeightDataList"][4]["WeightValue"].to_f,json["WeightDataList"][5]["WeightValue"].to_f,json["WeightDataList"][6]["WeightValue"].to_f]
	  			average = arr.inject{ |sum, el| sum + el }.to_f / arr.size
	  			difference = last_weight_measure - average
	  			difference = difference * 2.2 if weight_unit.to_i == 0
	  			if(difference > 0)
	  				
	  				to_return[:incremental] = difference 
	  			else
	  				to_return[:decremental] = difference.abs 
	  			end
	  		end


	  		rescue
	  			to_return = {}
	  		end
	  	
  		return to_return

  	end
  end

  def get_partial
  	if(self.device_type == "OpenApiWeight")
  		return '/devices/ihealth_weight_scale'
  	elsif(self.device_type == "OpenApiBP")
  		return '/devices/ihealth_blood_pressure'
  	end
  end

  def get_client_id
  	if(self.device_type == "OpenApiBP" || self.device_type == "OpenApiWeight")
  		return "98ee2da15c8d4bbba926ff7a368fc103"
  	else

  	end
  end

  def get_client_secret
  	if(self.device_type == "OpenApiBP" || self.device_type == "OpenApiWeight")
  	  return "8c30c6d9c8f84c55b2f50e39a982f6f7"
  	else

  	end
  end

  def get_api_host
  	if(self.device_type == "OpenApiBP")
  		return "api.ihealthlabs.com"
  	else

  	end
  end

  def get_api_path
  	if(self.device_type == "OpenApiBP")
  		return "/OpenApiV2/OAuthv2/userauthorization"
  	else

  	end
  end

	def list_of_supported_devices
		devices = []
		devices << {:name => "",
			:description => "",
			:image => "",
			:device_type => "OpenApiBP", 
			:buy_link => "",
		}

		devices << {:name => "",
			:description => "",
			:image => "",
			:device_type => "OpenApiWeight", 
			:buy_link => "",
		}

		return devices

  end

 def self.food_yiftee_token
 	return "ee8201d264adf7cdb60e4a0de478bf8b13"
 end

 	def self.transport_yiftee_token
 	return "9f6f71b6c6afefd1f2519b7fa11a297914"
 end

 	def self.gift_yiftee_token
 	return "7cfa9357a33cb5bddb9ce3881197523e15"
 end
end
