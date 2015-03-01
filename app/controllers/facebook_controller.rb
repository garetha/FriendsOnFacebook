require 'net/http'
require 'cgi'
require 'json'
require 'facebook/user_info'


class FacebookController < ApplicationController
  GET_ACCESS_TOKEN_URL = "https://graph.facebook.com/oauth/access_token?client_id=431545406911968&redirect_uri=#{ENV['HOST_ADDRESS']}/done&client_secret=9806a77e7fc7f1843f392f1571f2e204&code="
  GET_USER_INFO_URL = "https://graph.facebook.com/me?fields=name,picture,friends&access_token="
  GET_USER_ACCESS_URL = "https://www.facebook.com/dialog/oauth?client_id=431545406911968&scope=user_friends&redirect_uri=#{ENV['HOST_ADDRESS']}/done"
  
  def index
    redirect_to GET_USER_ACCESS_URL
  end
  
  def done
    code = params[:code]
      
    if(code != nil)
      token_res = get_access_token(code)
      
      if(token_res.code.eql? '200')
        access_token = CGI::parse(token_res.body)['access_token'].join        
        user_res = get_user_info(access_token)   
        
        if(user_res.code.eql? '200')
          session[:user_info] = user_res.body
          redirect_to :show
        else
          error = JSON.parse(user_res.body)
          flash.now[:error] = error['error']['message']
          render :show, status: :bad_request
        end

      else
        error = JSON.parse(token_res.body)
        flash.now[:error] = error['error']['message']
        render :show,  status: :bad_request
      end
      
    else
      flash.now[:error] = 'Login cancelled' 
      render :show, status: :bad_request     
    end
  end
  
  def show
    user_info_data = JSON.parse(session[:user_info]) # just to avoid caching
    @user_info =  UserInfo.new(user_info_data)
  end
  
  private
  
  def get_user_info(access_token)
    uri = URI.parse(GET_USER_INFO_URL+access_token)  
    return get_https_response(uri)    
  end
  
  
  def get_access_token(code)    
    uri = URI.parse(GET_ACCESS_TOKEN_URL+code)  
    return get_https_response(uri)    
  end
  
  def get_https_response(uri) 
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    return http.request(request)
  end
end
