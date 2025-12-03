module YouTube
  class Channel < Object
    include ThumbnailExtractor

    def initialize(options = {})
      super options

      if options["snippet"]
        self.title        = options["snippet"]["title"]
        self.description  = options["snippet"]["description"]
        self.published_at = options["snippet"]["publishedAt"]
        extract_thumbnails(options["snippet"])
      end

      if options["status"]
        self.privacy_status      = options["status"]["privacyStatus"]
        self.long_uploads_status = options["status"]["longUploadsStatus"]
      end
    end

  end
end
