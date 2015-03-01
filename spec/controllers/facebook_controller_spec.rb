require 'rails_helper'

RSpec.describe FacebookController, type: :controller do
  describe 'GET index' do
    it 'should redirect to facebook login' do         
      get :index
      expect(response).to redirect_to('https://www.facebook.com/dialog/oauth?client_id=431545406911968&scope=user_friends&redirect_uri=http://localhost:3000/done')
    end
  end
    
  describe 'GET done' do
    it 'should request access token from facebook and render results' do
      VCR.use_cassette 'controller/facebook_login_success_response' do            
        get :done, 'code' => 'AQCpMw_f0aIruBi-PEs341sZziqOS64SjgYaJhV1rt8f-lC8zcKxcKw4A9VKxMyHt5_o1iwkkh5V-wFWlB3H_nv1cOImvDYAHJY4hXGrt6bPDX6uWVrkLLGKBZlXFRqHEJbPG55-7SlOadslMQ8yj-ocnPm_4MeqYXRe1-ijvIT0xc9XwCHImJ5UCu5XgjoZUCPb27FMiezYuwanWqp07J27bPMPY-e88MLp3lVc1RjxGuA8hgJOACDDLGGgxIZ6s-00tkdwYjMPPYSQ5CK3W8VZA2f635LzrWlLHhr9Dj4326OhVsDinFG8ywRzbrE4BaY'
        expect(response).to render_template('done')
      end
    end

    it 'should render error when code is invalid' do
      VCR.use_cassette 'controller/facebook_login_invalid_code_response' do            
        get :done, 'code' => '123'
        expect(response).to render_template('done')
      end
    end
    
    it 'should render error when access token is invalid' do
      VCR.use_cassette 'controller/facebook_login_invalid_access_token_response' do            
        get :done, 'code' => '123'
        expect(response).to render_template('done')
      end
    end
  end
  
end
