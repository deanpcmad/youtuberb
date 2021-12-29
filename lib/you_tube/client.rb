module YouTube
  class Client
    BASE_URL = "https://www.googleapis.com/youtube/v3/"

    attr_reader :api_key, :adapter

    def initialize(api_key:, adapter: Faraday.default_adapter, stubs: nil)
      @api_key = api_key
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

    def connection
      @connection ||= Faraday.new(BASE_URL) do |conn|
        # conn.request :authorization, :Bearer, access_token
        # conn.headers = { "Client-ID": client_id }
        conn.request :json

        conn.response :dates
        conn.response :json, content_type: "application/json"

        conn.adapter adapter, @stubs
      end
    end

  end
end