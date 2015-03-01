class UserInfo
  attr_reader :name, :picture_url, :friends_list
  
  def initialize(attrs={})
    
    if(attrs != nil)      
      @name = attrs['name']
      @picture_url = get_picture_url(attrs)
      @friends_list = get_friends_list(attrs)
    end
  end
  
  private
    
    def get_picture_url(attrs)
      if(attrs.has_key? 'picture')
        if(attrs['picture'].has_key? 'data')
          return attrs['picture']['data']['url']
        end
      end
    end
    
    def get_friends_list(attrs)
      if(attrs.has_key? 'friends')
        return attrs['friends']['data']
      end
    end
      
  
end

{"name"=>"Gaz Allen", "picture"=>{"data"=>{"is_silhouette"=>false, "url"=>"https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xfa1/v/t1.0-1/c129.39.462.462/s50x50/545126_10150891918844251_956595368_n.jpg?oh=32956ac4671a7c5559da366cd6f32a70&oe=5590D96C&__gda__=1434999684_40de4af47fa5caa79e9c9d6ca40e9f94"}}, "friends"=>{"data"=>[], "summary"=>{"total_count"=>80}}, "id"=>"10153662627849251"}