module YouTube
  class Client
    BASE_URL = "https://www.googleapis.com/youtube/v3/"

    attr_reader :api_key, :access_token, :adapter

    def initialize(api_key:, access_token: nil, adapter: Faraday.default_adapter)
      @api_key = api_key
      @access_token = access_token
      @adapter = adapter
    end

    def channels
      ChannelsResource.new(self)
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

    def search
      SearchResource.new(self)
    end

    def connection
      @connection ||= Faraday.new(BASE_URL) do |conn|
        conn.request :authorization, :Bearer, access_token
        conn.request :json

        conn.response :json, content_type: "application/json"

        conn.adapter adapter, @stubs
      end
    end

  end
end
