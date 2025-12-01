module YouTube
  class ChannelsResource < Resource

    PARTS = "id,snippet,status,statistics,contentDetails"

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
      raise ArgumentError, "Must provide either an ID or Username" if attrs.empty?

      response = get_request "channels", params: attrs.merge({part: PARTS})
      return nil if response.body["pageInfo"]["totalResults"] == 0
      Channel.new(response.body["items"][0])
    end

    def videos(id:, **options)
      response = get_request "search", params: {channelId: id, part: "id,snippet"}.merge(options)
      Collection.from_response(response, type: SearchResult)
    end

  end
end
