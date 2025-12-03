module YouTube
  class SearchResult < Object
    include ThumbnailExtractor
    include SnippetExtractor

    def initialize(options = {})
      super options

      if options["id"]
        self.video_id    = options["id"]["videoId"] || nil
        self.playlist_id = options["id"]["playlistId"] || nil
      end

      extract_snippet(options["snippet"])
    end

  end
end
