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

    # Uploads a video
    # Currently just uploads a video
    # Needs more testing
    # https://developers.google.com/youtube/v3/docs/videos/insert
    def upload(file:)
      payload = {}
      payload[:media] = Faraday::Multipart::FilePart.new(file, "video/*")

      response = client.connection_upload.post "videos", payload
      
      response.body
    end

  end
end
