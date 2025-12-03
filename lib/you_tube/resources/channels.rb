module YouTube
  class ChannelsResource < Resource

    PARTS = "id,snippet,status,statistics,contentDetails"

    # Retrieve the channel of the currently authenticated user
    def mine
      response = get_request "channels", params: {mine: true, part: PARTS}
      items = response.body["items"]
      return nil if items.nil? || items.empty?
      Channel.new(items[0])
    end

    # Retrieve a Channel by its ID, Username or Handle (@username)
    def retrieve(id: nil, username: nil, handle: nil)
      attrs = {}
      attrs[:id] = id if id
      attrs[:forUsername] = username if username
      attrs[:forHandle] = handle if handle
      raise ArgumentError, "Must provide either an ID, Username or Handle" if attrs.empty?

      response = get_request "channels", params: attrs.merge({part: PARTS})
      items = response.body["items"]
      return nil if items.nil? || items.empty?
      Channel.new(items[0])
    end

    def videos(id:, **options)
      params = {channelId: id, part: "id,snippet"}.merge(options)
      response = get_request "search", params: params

      next_callback = ->(token) { videos(id: id, page_token: token, **options) }
      prev_callback = ->(token) { videos(id: id, page_token: token, **options) }

      Collection.from_response(
        response,
        type: SearchResult,
        next_page_callback: next_callback,
        prev_page_callback: prev_callback
      )
    end

  end
end
