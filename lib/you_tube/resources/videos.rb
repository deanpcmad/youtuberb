module YouTube
  class VideosResource < Resource

    PARTS = "id,snippet,contentDetails,liveStreamingDetails,statistics,status"
    AUTH_PARTS = "id,snippet,contentDetails,fileDetails,processingDetails,statistics,status,suggestions"

    # Retrieves Videos by ID. Can be comma separated to retrieve multiple.
    def list(id: nil, ids: nil)
      raise "Either id or ids is required" unless !id.nil? || !ids.nil?

      if id
        response = get_request("videos", params: {id: id, part: PARTS})
      elsif ids
        response = get_request("videos", params: {id: ids.join(","), part: PARTS})
      end

      body = response.body["items"]
      if body.count == 1
        Video.new body[0]
      elsif body.count > 1
        Collection.from_response(response, type: Video)
      else
        return nil
      end
    end

    # Retrieves liked Videos for the currently authenticated user
    def liked
      response = get_request "videos", params: {myRating: "like", part: PARTS}
      Collection.from_response(response, type: Video)
    end

    # Retrieves a Video by the ID. This retrieves extra information so will only work
    # on videos for an authenticated user
    def retrieve(id:)
      response = get_request "videos", params: {id: id, part: AUTH_PARTS}
      return nil if response.body["pageInfo"]["totalResults"] == 0
      Video.new(response.body["items"][0])
    end

  end
end
