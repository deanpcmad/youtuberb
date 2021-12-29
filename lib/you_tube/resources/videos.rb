module YouTube
  class VideosResource < Resource
    
    def list
      response = get_request "videos", params: {chart: "mostPopular"}
      # response = post_request("games", body: "fields id,name,status,url,created_at,updated_at;")
      Collection.from_response(response, type: Video)
    end

  end
end
