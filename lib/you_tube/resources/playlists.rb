module YouTube
  class PlaylistsResource < Resource
    
    def list
      parts = ["id", "snippet", "status"]
      response = get_request "playlists", params: {mine: true, part: parts.join(",")}
      Collection.from_response(response, type: Playlist)
    end

  end
end
