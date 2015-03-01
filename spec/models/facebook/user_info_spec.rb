require 'rails_helper'

RSpec.describe UserInfo, type: :model do
  
  it "should populate name" do
    ui = UserInfo.new(get_raw_data)
    expect(ui.name).to eq("Test User")     
  end
  
  it "should populate picture_url" do
    ui = UserInfo.new(get_raw_data)
    expect(ui.picture_url).to eq("https://test_img_url")
  end
  
  it "should populate nil for picture_url if picture node is missing" do
    data = {}
    data.merge!(get_raw_data)
    data.delete('picture')
    ui = UserInfo.new(data)
    expect(ui.picture_url).to eq(nil)
  end
  
  it "should populate nil for picture_url if picture>data node is missing" do
    data = {}
    data.merge!(get_raw_data)
    data['picture'].delete('data')
    ui = UserInfo.new(data)
    expect(ui.picture_url).to eq(nil)
  end
  
  it "should populate friends list" do
    ui = UserInfo.new(get_raw_data)
    expect(ui.friends_list.size).to eq(1)
    expect(ui.friends_list[0]['name']).to eq("test friend")        
  end
  
  def get_raw_data
    return {"name"=>"Test User", "picture"=>{"data"=>{"is_silhouette"=>false, "url"=>"https://test_img_url"}}, "friends"=>{"data"=>[{"name" => "test friend"}], "summary"=>{"total_count"=>80}}, "id"=>"123"}
  end
end
