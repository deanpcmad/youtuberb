module YouTube
  class LiveBroadcastsResource < Resource

    PARTS = "id,snippet,contentDetails,status"

    # Retrieves Live Broadcasts by ID or for the currently authenticated user
    def list(status: nil, **options)
      if status
        params = {broadcastStatus: status, part: PARTS}.merge(options)
      else
        params = {mine: true, part: PARTS}.merge(options)
      end

      response = get_request("liveBroadcasts", params: params)

      next_callback = ->(token) { list(status: status, page_token: token, **options) }
      prev_callback = ->(token) { list(status: status, page_token: token, **options) }

      Collection.from_response(
        response,
        type: LiveBroadcast,
        next_page_callback: next_callback,
        prev_page_callback: prev_callback
      )
    end

    # Retrieves a Video by the ID. This retrieves extra information so will only work
    # on videos for an authenticated user
    def retrieve(id:)
      response = get_request "liveBroadcasts", params: {id: id, part: PARTS}
      items = response.body["items"]
      return nil if items.nil? || items.empty?
      LiveBroadcast.new(items[0])
    end

  end
end
