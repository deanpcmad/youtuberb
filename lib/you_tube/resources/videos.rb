module YouTube
  class VideosResource < Resource

    PARTS = "id,snippet,contentDetails,liveStreamingDetails,statistics,status"
    AUTH_PARTS = "id,snippet,contentDetails,fileDetails,processingDetails,statistics,status,suggestions"

    # Retrieves Videos by ID. Can be comma separated to retrieve multiple.
    def list(id: nil, ids: nil)
      raise ArgumentError, "Either id or ids is required" if id.nil? && ids.nil?

      if id
        response = get_request("videos", params: {id: id, part: PARTS})
      elsif ids
        response = get_request("videos", params: {id: ids.join(","), part: PARTS})
      end

      items = response.body["items"]
      return nil if items.nil? || items.empty?

      if items.count == 1
        Video.new(items[0])
      else
        Collection.from_response(response, type: Video)
      end
    end

    # Retrieves liked Videos for the currently authenticated user
    def liked(**options)
      params = {myRating: "like", part: PARTS}.merge(options)
      response = get_request "videos", params: params

      next_callback = ->(token) { liked(pageToken: token, **options.except(:pageToken)) }
      prev_callback = ->(token) { liked(pageToken: token, **options.except(:pageToken)) }

      Collection.from_response(
        response,
        type: Video,
        next_page_callback: next_callback,
        prev_page_callback: prev_callback
      )
    end

    # Retrieves a Video by the ID. This retrieves extra information so will only work
    # on videos for an authenticated user
    def retrieve(id:)
      response = get_request "videos", params: {id: id, part: AUTH_PARTS}
      items = response.body["items"]
      return nil if items.nil? || items.empty?
      Video.new(items[0])
    end

  end
end
