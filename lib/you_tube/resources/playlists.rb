module YouTube
  class PlaylistsResource < Resource
    
    def list
      parts = ["id", "snippet", "status"]
      response = get_request "playlists", params: {mine: true, part: parts.join(",")}
      Collection.from_response(response, type: Playlist)
    end

    def create(title:, **attributes)
      attrs = {}
      attrs[:snippet] = {}
      attrs[:status] = {}

      attrs[:snippet][:title] = title

      attrs[:snippet][:description]     = attributes[:description]
      attrs[:snippet][:defaultLanguage] = attributes[:default_language]

      attrs[:status][:privacyStatus]    = attributes[:privacy_status]

      response = post_request("playlists?part=id,snippet,status", body: attrs)
      
      Playlist.new(response.body) if response.success?
    end

    def delete(id:)
      delete_request("playlists?id=#{id}")
    end

  end
end
