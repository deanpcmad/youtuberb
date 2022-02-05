module YouTube
  class PlaylistsResource < Resource

    PARTS = "id,snippet,status"
    
    # Returns Playlists either for a Channel or owned by the authenticated user
    # https://developers.google.com/youtube/v3/docs/playlists/list
    def list(channel_id: nil, page_token: nil, max_results: nil)
      attrs = {}
      if channel_id
        attrs[:channelId] = channel_id
      else
        attrs[:mine] = true
      end
      attrs[:maxResults] = max_results if max_results
      attrs[:pageToken]  = page_token  if page_token

      response = get_request "playlists", params: attrs.merge({part: PARTS})
      Collection.from_response(response, type: Playlist)
    end

    # Returns a Playlist for a given ID
    def retrieve(id:)
      response = get_request "playlists", params: {id: id, part: PARTS}
      Playlist.new(response.body["items"][0])
    end

    # Creates a Playlist
    # https://developers.google.com/youtube/v3/docs/playlists/insert
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

    # Updates a Playlist. ID and Title are required.
    # https://developers.google.com/youtube/v3/docs/playlists/update
    def update(id:, title:, **attributes)
      attrs = {}
      attrs[:id] = id
      attrs[:snippet] = {}
      attrs[:status] = {}

      attrs[:snippet][:title] = title

      attrs[:snippet][:description]     = attributes[:description]
      attrs[:snippet][:defaultLanguage] = attributes[:default_language]

      attrs[:status][:privacyStatus]    = attributes[:privacy_status]

      response = put_request("playlists?part=id,snippet,status", body: attrs)
      
      Playlist.new(response.body) if response.success?
    end

    # Deletes a Playlist
    # https://developers.google.com/youtube/v3/docs/playlists/delete
    def delete(id:)
      delete_request("playlists?id=#{id}")
    end

  end
end
