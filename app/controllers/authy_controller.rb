require 'openssl'
require 'base64'

class AuthyController < ApplicationController
 # Before we allow the incoming request to callback, verify
 # that it is an Authy request
 before_action :authenticate_authy_request, :only => [
   :callback
 ]

 protect_from_forgery except: [:callback, :send_token]

 # The webhook setup for our Authy application this is where
 # the response from a OneTouch request will come
 def callback
   authy_id = params[:authy_id]
     begin
       @user = User.find_by! authy_id: authy_id
       @user.update(authy_status: params[:status])
     rescue => e
       puts e.message
     end

   render plain: 'ok'
 end

 #  renders user's status and if approved, it signs in the user
 def one_touch_status
   @user = User.find(session[:pre_2fa_auth_user_id])
   session[:user_id] = if @user.approved?
                          @user.id
                          sign_in(@user)
                       else
                        nil
                       end
   render plain: @user.authy_status
 end

 # Authenticate that all requests to our public-facing callback are
 # coming from Authy. Adapted from the explanation at
 # https://www.twilio.com/docs/authy/api/webhooks#signing-requests
 private
 def authenticate_authy_request
   url = request.url
   raw_params = JSON.parse(request.raw_post)
   nonce = request.headers["X-Authy-Signature-Nonce"]
   sorted_params = (Hash[raw_params.sort]).to_query

   # data format of Authy digest
   data = nonce + "|" + request.method + "|" + url + "|" + sorted_params

   digest = OpenSSL::HMAC.digest('sha256', Authy.api_key, data)
   digest_in_base64 = Base64.encode64(digest)

   theirs = (request.headers['X-Authy-Signature']).strip
   mine = digest_in_base64.strip

   unless theirs == mine
     render plain: 'invalid request signature'
   end
 end
end
