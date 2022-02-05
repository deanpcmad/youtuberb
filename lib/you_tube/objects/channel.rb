module YouTube
  class Channel < Object

    def initialize(options = {})
      super options

      if options["snippet"]
        self.title        = options["snippet"]["title"]
        self.description  = options["snippet"]["description"]
        self.published_at = options["snippet"]["publishedAt"]

        if options["snippet"]["thumbnails"]
          thumb = options["snippet"]["thumbnails"]
          self.thumbnail_default  = thumb["default"]["url"]   if thumb["default"]
          self.thumbnail_medium   = thumb["medium"]["url"]    if thumb["medium"]
          self.thumbnail_high     = thumb["high"]["url"]      if thumb["high"]
          self.thumbnail_standard = thumb["standard"]["url"]  if thumb["standard"]
          self.thumbnail_maxres   = thumb["maxres"]["url"]    if thumb["maxres"]
        end
      end

      if options["status"]
        self.privacy_status      = options["status"]["privacyStatus"]
        self.long_uploads_status = options["status"]["longUploadsStatus"]
      end
    end

  end
end
