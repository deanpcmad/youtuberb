module YouTube
  class VideosResource < Resource

    PARTS = "id,contentDetails,fileDetails,processingDetails,snippet,statistics,status,suggestions"
    
    def list(id:)
      response = get_request "videos", params: {id: id, part: PARTS}
      Collection.from_response(response, type: Video)
    end

    def retrieve(id:)
      response = get_request "videos", params: {id: id, part: PARTS}
      Video.new(response.body["items"][0])
    end

  end
end
