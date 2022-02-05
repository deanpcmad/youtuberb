module YouTube
  class Client
    BASE_URL = "https://www.googleapis.com/youtube/v3/"

    attr_reader :api_key, :access_token, :adapter

    def initialize(api_key:, access_token:, adapter: Faraday.default_adapter, stubs: nil)
      @api_key = api_key
      @access_token = access_token
      @adapter = adapter

      # Test stubs for requests
      @stubs = stubs
    end

    def activities
      ActivitiesResource.new(self)
    end

    def videos
      VideosResource.new(self)
    end

    def playlists
      PlaylistsResource.new(self)
    end

    def playlist_items
      PlaylistItemsResource.new(self)
    end

    def connection
      @connection ||= Faraday.new(BASE_URL) do |conn|
        conn.request :authorization, :Bearer, access_token
        conn.request :json

        conn.response :dates
        conn.response :json, content_type: "application/json"

        conn.adapter adapter, @stubs
      end
    end

  end
end
