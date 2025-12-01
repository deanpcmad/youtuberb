module YouTube
  class LiveBroadcastsResource < Resource

    PARTS = "id,snippet,contentDetails,status"

    # Retrieves Live Broadcasts by ID or for the currently authenticated user
    def list(status: nil)
      if status
        response = get_request("liveBroadcasts", params: {broadcastStatus: status, part: PARTS})
      else
        response = get_request("liveBroadcasts", params: {mine: true, part: PARTS})
      end

      Collection.from_response(response, type: LiveBroadcast)
    end

    # Retrieves a Video by the ID. This retrieves extra information so will only work
    # on videos for an authenticated user
    def retrieve(id:)
      response = get_request "liveBroadcasts", params: {id: id, part: PARTS}
      return nil if response.body["items"].count == 0
      LiveBroadcast.new(response.body["items"][0])
    end

  end
end
