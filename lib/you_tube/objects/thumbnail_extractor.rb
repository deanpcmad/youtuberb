module YouTube
  module ThumbnailExtractor
    private

    def extract_thumbnails(options)
      return unless options["thumbnails"]

      thumb = options["thumbnails"]
      self.thumbnail_default = thumb["default"]["url"] if thumb["default"]
      self.thumbnail_medium = thumb["medium"]["url"] if thumb["medium"]
      self.thumbnail_high = thumb["high"]["url"] if thumb["high"]
      self.thumbnail_standard = thumb["standard"]["url"] if thumb["standard"]
      self.thumbnail_maxres = thumb["maxres"]["url"] if thumb["maxres"]
    end
  end
end
