module YouTube
  class PlaylistItemsResource < Resource

    PARTS = "id,snippet,status,contentDetails"

    # Returns Playlist Items for a Playlist
    # https://developers.google.com/youtube/v3/docs/playlistItems/list
    def list(playlist_id:)
      response = get_request "playlistItems", params: {playlistId: playlist_id, part: PARTS}
      Collection.from_response(response, type: PlaylistItem)
    end

    # Returns a Playlist Item for a given ID
    # https://developers.google.com/youtube/v3/docs/playlistItems/list
    def retrieve(id:)
      response = get_request "playlistItems", params: {id: id, part: PARTS}
      items = response.body["items"]
      return nil if items.nil? || items.empty?
      PlaylistItem.new(items[0])
    end

    # Creates a Playlist Item
    # https://developers.google.com/youtube/v3/docs/playlistItems/insert
    def create(playlist_id:, video_id:, **attributes)
      attrs = {}
      attrs[:snippet] = {}
      attrs[:status] = {}

      attrs[:snippet][:playlistId] = playlist_id
      attrs[:snippet][:resourceId] = {kind: "youtube#video", videoId: video_id}

      attrs[:snippet][:position] = attributes[:position]

      response = post_request("playlistItems?part=id,snippet,status", body: attrs)
      PlaylistItem.new(response.body)
    end

    # Updates a Playlist Item. ID, Playlist ID and Video ID are required.
    # https://developers.google.com/youtube/v3/docs/playlistItems/update
    def update(id:, playlist_id:, video_id:, **attributes)
      attrs = {}
      attrs[:id] = id
      attrs[:snippet] = {}
      attrs[:status] = {}

      attrs[:snippet][:playlistId] = playlist_id
      attrs[:snippet][:resourceId] = {kind: "youtube#video", videoId: video_id}

      attrs[:snippet][:position] = attributes[:position]

      response = put_request("playlistItems?part=id,snippet,status", body: attrs)
      PlaylistItem.new(response.body)
    end

    # Deletes a Playlist Item
    # https://developers.google.com/youtube/v3/docs/playlistItems/delete
    def delete(id:)
      delete_request("playlistItems?id=#{id}")
    end

  end
end
