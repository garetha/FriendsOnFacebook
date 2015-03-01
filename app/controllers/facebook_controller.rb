require 'net/http'
require 'cgi'
require 'json'
require 'facebook/user_info'


class FacebookController < ApplicationController
  GET_ACCESS_TOKEN_URL = 'https://graph.facebook.com/oauth/access_token?client_id=431545406911968&redirect_uri=http://localhost:3000/done&client_secret=9806a77e7fc7f1843f392f1571f2e204&code='
  GET_USER_INFO_URL = 'https://graph.facebook.com/me?fields=name,picture,friends&access_token='
  
  def index
    redirect_to 'https://www.facebook.com/dialog/oauth?client_id=431545406911968&scope=user_friends&redirect_uri=http://localhost:3000/done'
  end
  
  def done
      puts params.to_s
      code = params[:code]
      
      access_token = get_access_token(code)
      if(access_token != nil) 
        get_user_info(access_token)
      else
        puts 'Access token not retrieved'
      end
  end
  
  private
  
  def get_user_info(access_token)
    puts '----access_token=' + access_token
    
    uri = URI.parse(GET_USER_INFO_URL+access_token)  
    res = get_https_response(uri)
    user_info_data = JSON.parse(res.body)
    @user_info = UserInfo.new(user_info_data)
    puts @user_info.name
    puts @user_info.picture_url
    puts @user_info.friends_list
  end
  
  
  def get_access_token(code)  
    if(code != nil)
      puts '------code=' + code
      
      uri = URI.parse(GET_ACCESS_TOKEN_URL+code)  
      res = get_https_response(uri)
      params = CGI::parse(res.body)
      if(params.has_key? 'access_token')
        return params['access_token'].join
      end
    else
      puts 'Code is missing'
    end
  end
  
  def get_https_response(uri) 
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    return http.request(request)
  end
end
