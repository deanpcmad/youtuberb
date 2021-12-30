module YouTube
  class VideosResource < Resource
    
    def list(id:)
      parts = ["contentDetails", "fileDetails", "id", "localizations", "processingDetails", "recordingDetails", "snippet", "statistics", "status", "suggestions", "topicDetails"]
      response = get_request "videos", params: {id: id, part: parts.join(",")}
      # response = post_request("games", body: "fields id,name,status,url,created_at,updated_at;")
      Collection.from_response(response, type: Video)
    end

  end
end
