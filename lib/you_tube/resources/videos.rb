module YouTube
  class VideosResource < Resource

    PARTS = "id,contentDetails,snippet,statistics,status"
    AUTH_PARTS = "id,contentDetails,fileDetails,processingDetails,snippet,statistics,status,suggestions"
    
    # Retrieves Videos by ID. Can be comma separated to retrieve multiple.
    def list(id:)
      response = get_request "videos", params: {id: id, part: PARTS}
      Collection.from_response(response, type: Video)
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
