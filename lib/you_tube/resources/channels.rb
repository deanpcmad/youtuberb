module YouTube
  class ChannelsResource < Resource

    PARTS = "id,snippet,status,statistics"

    # Retrieve the channel of the currently authenticated user
    def mine
      response = get_request "channels", params: {mine: true, part: PARTS}
      return nil if response.body["pageInfo"]["totalResults"] == 0
      Channel.new(response.body["items"][0])
    end
    
    # Retrieve a Channel by its ID or Username
    def retrieve(id: nil, username: nil)
      attrs = {}
      attrs[:id] = id if id
      attrs[:forUsername] = username if username

      response = get_request "channels", params: attrs.merge({part: PARTS})
      return nil if response.body["pageInfo"]["totalResults"] == 0
      Channel.new(response.body["items"][0])
    end

  end
end
