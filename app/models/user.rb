require 'mandrill'


class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :phone, :relationship, :remote
  
  has_secure_password
  validates_presence_of :email, :on => :create
  validates_uniqueness_of :email, :on => :create
  validates_presence_of :password, :on => :create

  belongs_to :patient

  def self.invite(name, email, patient)
  	logger.debug "hello"
  	patient_name = (patient.name).capitalize
  	recipient_name = name.capitalize
  	recipient_email = email
  	url = "/signup?patient_id=" + patient.id.to_s
  	his_label = patient.gender == "male" ? "his" : "her"
  	begin
		    mandrill = Mandrill::API.new 'g2DWqnLd9Ac6yUPwWXOODw'
		    template_name = "Invite Letter"
		    template_content = [{"name"=>"example name", "content"=>"example content"}]
		    message = {"metadata"=>{"website"=>"www.yiftee.com"},
		     "global_merge_vars"=>nil,
		     "merge"=>false,
		     "signing_domain"=>nil,
		     "inline_css"=>true,
		     "from_name"=>"Bob - Caregiver's Favorite Assistant",
		     "subaccount"=>nil,
		     "url_strip_qs"=>nil,
		     "html"=>"<p>Example HTML content</p>",
		     "merge_vars"=>
		        [
            {
                "rcpt"=> recipient_email,
                "vars"=> [
                    {
                        "name"=> "fname",
                        "content"=> name
                    },
                    {
                        "name"=> "patient",
                        "content"=> patient_name
                    }
                ]
            }
        ],
		     "return_path_domain"=>nil,
		     "tags"=>nil,
		     "tracking_domain"=>nil,
		     "track_opens"=>nil,
		     "to"=>
		        [{"type"=>"to",
		            "name"=>name,
		            "email"=>recipient_email}],
		     "recipient_metadata"=>
		        [{"values"=>{"user_id"=>123456}, "rcpt"=>"recipient.email@example.com"}],
		     "google_analytics_campaign"=>nil,
		     "google_analytics_domains"=>nil,
		     "preserve_recipients"=>nil,
		     "images"=>
		        nil,
		     "bcc_address"=>nil,
		     "from_email"=>"michelle.hernandez.rosa@gmail.com",
		     "view_content_link"=>nil,
		     "auto_text"=>nil,
		     "attachments"=>
		        nil,
		     "subject"=> patient_name + " is inviting you to become part of " + his_label + " team",
		     "auto_html"=>nil,
		     "headers"=>{"Reply-To"=>"michelle.hernandez.rosa@gmail.com"},
		     "important"=>false,
		     "text"=>patient_name + " is inviting you to become part of " + his_label + " team",
		     "track_clicks"=>nil}
		    async = false
		    ip_pool = "Main Pool"
		    send_at = nil
		    result = mandrill.messages.send_template template_name, template_content, message, async, ip_pool, send_at    # [{"status"=>"sent",
		        #     "reject_reason"=>"hard-bounce",
		        #     "_id"=>"abc123abc123abc123abc123abc123",
		        #     "email"=>"recipient.email@example.com"}]
		    logger.debug result
		rescue Mandrill::Error => e
		    # Mandrill errors are thrown as exceptions
		    logger.debug "A mandrill error occurred: #{e.class} - #{e.message}"
		    # A mandrill error occurred: Mandrill::UnknownSubaccountError - No subaccount exists with the id 'customer-123'    
		    raise
		end
  end

  def test_mandrill
  	begin
		    mandrill = Mandrill::API.new 'g2DWqnLd9Ac6yUPwWXOODw'
		    template_name = "Invite Letter"
		    template_content = [{"name"=>"example name", "content"=>"example content"}]
		    message = {"metadata"=>{"website"=>"www.yiftee.com"},
		     "global_merge_vars"=>nil,
		     "merge"=>false,
		     "signing_domain"=>nil,
		     "inline_css"=>true,
		     "from_name"=>"Bob - Caregiver's Favorite Assistant",
		     "subaccount"=>nil,
		     "url_strip_qs"=>nil,
		     "html"=>"<p>Example HTML content</p>",
		     "merge_vars"=>
		        [
            {
                "rcpt"=> "aldo@yiftee.com",
                "vars"=> [
                    {
                        "name"=> "fname",
                        "content"=> "Aldo"
                    },
                    {
                        "name"=> "patient",
                        "content"=> "Julio"
                    }
                ]
            }
        ],
		     "return_path_domain"=>nil,
		     "tags"=>nil,
		     "tracking_domain"=>nil,
		     "track_opens"=>nil,
		     "to"=>
		        [{"type"=>"to",
		            "name"=>"Aldo",
		            "email"=>"aldo@yiftee.com"}],
		     "recipient_metadata"=>
		        [{"values"=>{"user_id"=>123456}, "rcpt"=>"recipient.email@example.com"}],
		     "google_analytics_campaign"=>nil,
		     "google_analytics_domains"=>nil,
		     "preserve_recipients"=>nil,
		     "images"=>
		        nil,
		     "bcc_address"=>nil,
		     "from_email"=>"michelle.hernandez.rosa@gmail.com",
		     "view_content_link"=>nil,
		     "auto_text"=>nil,
		     "attachments"=>
		        nil,
		     "subject"=>"example subject",
		     "auto_html"=>nil,
		     "headers"=>{"Reply-To"=>"michelle.hernandez.rosa@gmail.com"},
		     "important"=>false,
		     "text"=>"Hello test",
		     "track_clicks"=>nil}
		    async = false
		    ip_pool = "Main Pool"
		    send_at = nil
		    result = mandrill.messages.send_template template_name, template_content, message, async, ip_pool, send_at    # [{"status"=>"sent",
		        #     "reject_reason"=>"hard-bounce",
		        #     "_id"=>"abc123abc123abc123abc123abc123",
		        #     "email"=>"recipient.email@example.com"}]
		    
		rescue Mandrill::Error => e
		    # Mandrill errors are thrown as exceptions
		    puts "A mandrill error occurred: #{e.class} - #{e.message}"
		    # A mandrill error occurred: Mandrill::UnknownSubaccountError - No subaccount exists with the id 'customer-123'    
		    raise
		end
	end
end
