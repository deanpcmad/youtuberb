module YouTube
  class SearchResult < Object
    include ThumbnailExtractor

    def initialize(options = {})
      super options

      if options["id"]
        self.video_id    = options["id"]["videoId"] || nil
        self.playlist_id = options["id"]["playlistId"] || nil
      end

      if options["snippet"]
        self.title        = options["snippet"]["title"]
        self.description  = options["snippet"]["description"]
        self.published_at = options["snippet"]["publishedAt"]
        self.channel_id   = options["snippet"]["channelId"]
        extract_thumbnails(options["snippet"])
      end
    end

  end
end
