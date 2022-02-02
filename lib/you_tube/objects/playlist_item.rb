module YouTube
  class PlaylistItem < Object

    def initialize(options = {})
      super options

      if options["snippet"]
        self.title        = options["snippet"]["title"]
        self.description  = options["snippet"]["description"]
        self.published_at = options["snippet"]["publishedAt"]

        if options["snippet"]["thumbnails"]
          self.thumbnail_default  = options["snippet"]["thumbnails"]["default"]["url"]
          self.thumbnail_medium   = options["snippet"]["thumbnails"]["medium"]["url"]
          self.thumbnail_high     = options["snippet"]["thumbnails"]["high"]["url"]
          self.thumbnail_standard = options["snippet"]["thumbnails"]["standard"]["url"]
          self.thumbnail_maxres   = options["snippet"]["thumbnails"]["maxres"]["url"]
        end
      end

      if options["status"]
        self.privacy_status = options["status"]["privacyStatus"]
      end
    end

  end
end
